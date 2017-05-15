//
//  ViewController.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/13.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import DynamicColor
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, ToolBarViewDelegate, UserDefaultable {

  fileprivate weak var tableView: UITableView?
  fileprivate weak var toolBarView: ToolBarView?
  fileprivate weak var imageView: UIImageView?
  fileprivate var tempHUD: MBProgressHUD?
  fileprivate var animatedView: WaitingVoiceView?
  fileprivate var mathView: MathView!

  fileprivate let disposedBag = DisposeBag()

  fileprivate var dataSources = Variable([String]())
  
  /// 音频流识别过程中pcm文件地址
  fileprivate var pcmFilePath: String?
  /// 识别对象
  fileprivate var speechRecognizer: IFlySpeechRecognizer?
  /// 数据上传对象 --> 主要是和上传联系人有关
  fileprivate var uploader: IFlyDataUploader?
  /// PCM 录音器，用于音频流识别的数据传入
  fileprivate var pcmRecorder: IFlyPcmRecorder?
  /// 是否是音频流识别
  fileprivate var isStreamRec: Bool = false
  /// 是否返回BeginOfSpeed回调
  fileprivate var isBeginOfSpeed: Bool = false

  fileprivate var isRecording: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    automaticallyAdjustsScrollViewInsets = false
    view.backgroundColor = UIColor(hex: 0x232329)
    navigationItem.title = "语音识别"
    navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
  
    let leftItem = UIBarButtonItem(title: "清空", style: .plain, target: nil, action: nil)
    self.navigationItem.leftBarButtonItem = leftItem
    
    leftItem.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.dataSources.value.removeAll()
      })
      .disposed(by: disposedBag)

    let rightItem = UIBarButtonItem.init(title: "设置", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    self.navigationItem.rightBarButtonItem = rightItem

    rightItem.rx.tap
      .subscribe(onNext: { [weak self] in
        let settingVC = SettingViewController()
        self?.navigationController?.show(settingVC, sender: nil)
      })
      .addDisposableTo(disposedBag)

    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
      .then({
        $0.backgroundColor = UIColor.clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 80
        $0.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        $0.contentOffset = CGPoint(x: 0, y: 0)
        $0.registerCell(SpeedResultCell.self)
      })

    self.tableView = tableView
    view.addSubview(tableView)

    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "bg2")
    view.insertSubview(imageView, at: 0)
    self.imageView = imageView

    let toolBarView = ToolBarView().then({
      $0.backgroundColor = UIColor(hex: 0xeeeeee)
      //      $0.delegate = self
    })
    self.toolBarView = toolBarView
    view.addSubview(toolBarView)

    makeContraints()

    uploader = IFlyDataUploader()

    let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    if let cachePath = paths.first {
      pcmFilePath = cachePath + "/asr.pcm"
    }

    //MARK : - Rx
    toolBarView.rx
      .setDelegate(self)
      .addDisposableTo(disposedBag)

    toolBarView.rx.buttonTap
      .asObservable()
      .observeOn(MainScheduler.instance)
      .subscribe { (event) in
        switch event {
        case .next(let state):
          self.speechButtonTouched(state: state)
        default:
          break
        }
      }
      .addDisposableTo(disposedBag)


    dataSources
      .asObservable()
      .bindTo(tableView.rx.items(cellIdentifier: SpeedResultCell.identifier, cellType: SpeedResultCell.self)) { [weak self] (row, element, cell) in
        cell.contentText = element
        guard let strongSelf = self else { return }
        let lastIndex = strongSelf.dataSources.value.count - 1
        if row == lastIndex {
          self?.tableView?.scrollTo(atRow: lastIndex, .none)
        }
      }
      .addDisposableTo(disposedBag)

    tableView.rx
      .setDelegate(self)
      .addDisposableTo(disposedBag)
    
    /// math view
    mathView = MathView()
      .then({
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1.0
      })
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    /// 初始化语音识别对象
    self.initRecognizer()
  }

  fileprivate func makeContraints() {
    tableView?.snp.makeConstraints({ [unowned self] in
      $0.top.equalTo(self.view.snp.top)
      $0.bottom.equalTo(self.view.snp.bottom)
      $0.left.equalTo(self.view.snp.left)
      $0.right.equalTo(self.view.snp.right)
    })

    toolBarView?.snp.makeConstraints({ [unowned self] in
      $0.left.equalTo(self.view.snp.left)
      $0.right.equalTo(self.view.snp.right)
      $0.bottom.equalTo(self.view.snp.bottom)
      $0.height.equalTo(49.0)
    })

    imageView?.snp.makeConstraints({ [unowned self] in
      $0.edges.equalTo(self.view)
    })
  }

  fileprivate func initRecognizer() {
    Log("")
    if speechRecognizer == nil {
      speechRecognizer = IFlySpeechRecognizer.sharedInstance()

      speechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
      // 设置听写模式
      speechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
      speechRecognizer?.delegate = self
    }
    let config = SpeechConfig.default
    speechRecognizer?.setParameter(config.speechTimeOut, forKey: IFlySpeechConstant.speech_TIMEOUT())
    speechRecognizer?.setParameter(config.vadEos, forKey: IFlySpeechConstant.vad_EOS())
    speechRecognizer?.setParameter(config.vadBos, forKey: IFlySpeechConstant.vad_BOS())
    speechRecognizer?.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())

    speechRecognizer?.setParameter(config.sampleRate, forKey: IFlySpeechConstant.sample_RATE())
    speechRecognizer?.setParameter(config.language, forKey: IFlySpeechConstant.language())
    speechRecognizer?.setParameter(config.accent, forKey: IFlySpeechConstant.accent())
    speechRecognizer?.setParameter("1", forKey: IFlySpeechConstant.asr_PTT())

    /// 初始化录音器
    if pcmRecorder == nil {
      pcmRecorder = IFlyPcmRecorder.sharedInstance()
    }
    pcmRecorder?.delegate = self

    pcmRecorder?.setSample(config.sampleRate)
    pcmRecorder?.setSaveAudioPath(nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension MainViewController {
  func speechButtonTouched(state: RecordState) {
      normalRecord(state: state)
  }
  
  private func normalRecord(state: RecordState) {
    switch state {
    case .recording:
      toolBarView?.title = "停止录音"
      title = "录音..."
      animatedView = WaitingVoiceView()
      view.addSubview(animatedView!)
      animatedView?.snp.makeConstraints({ [unowned self] (make) in
        make.left.equalTo(self.view.snp.left)
        make.right.equalTo(self.view.snp.right)
        make.bottom.equalTo(self.toolBarView!.snp.top)
        make.height.equalTo(88.0)
      })
      // 开始录音
      if speechRecognizer == nil {
        self.initRecognizer()
      }
      speechRecognizer?.cancel()
      speechRecognizer?.setParameter(IFLY_AUDIO_SOURCE_MIC, forKey: "audio_source")
      speechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
      speechRecognizer?.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
      speechRecognizer?.delegate = self
      if let startResult = speechRecognizer?.startListening() {
        if !startResult {
          let alertController = UIAlertController(title: "提醒",
                                                  message: "启动服务失败",
                                                  sureAction: { _ in
                                                    
          })
          
          alertController.show(in: self)
        }
      }
      break
    case .unrecord:
      toolBarView?.title = "开始录音"
      title = "录音结束，正在解析..."
      tempHUD = self.showHUD(in: view, title: "录音结束，正在解析...")
      speechRecognizer?.stopListening()
      break
    }
  }
}

extension MainViewController: HUDAble {
}

extension MainViewController: IFlySpeechRecognizerDelegate {
  func onResults(_ results: [Any]!, isLast: Bool) {
    var resultStr = String()
    print(results)
    guard let resultArray = results,
      let dict = resultArray.first as? [String: Any?] else {
        tempHUD?.hide(animated: false)
        self.showHUD(in: self.view, title: "没有检测到你的话", duration: 0.75)
        animatedView?.removeFromSuperview()
        animatedView = nil
        title = "语音识别"
        toolBarView?.title = "开始录音"
        return
    }
    for str in dict.keys {
      resultStr += str
    }
    if let resultFromJson = ISRDataHelper.string(fromJson: resultStr),
      resultFromJson.characters.count > 1 {
      dataSources.value.append(resultFromJson)
      showMathView(withLatex: resultFromJson)
    }
    tempHUD?.hide(animated: true)
    animatedView?.removeFromSuperview()
    animatedView = nil
    title = "语音识别"
  }
  func onError(_ errorCode: IFlySpeechError!) {
    Log(errorCode.errorCode)
    if errorCode.errorCode != 0 {
      self.showHUD(in: view, title: "识别失败", duration: 1.0)
      animatedView?.removeFromSuperview()
      animatedView = nil
    }
    title = "语音识别"
  }
}

extension MainViewController: IFlyPcmRecorderDelegate {
  func onIFlyRecorderVolumeChanged(_ power: Int32) {

  }

  func onIFlyRecorderError(_ recoder: IFlyPcmRecorder!, theError error: Int32) {
    Log(error)
  }

  func onIFlyRecorderBuffer(_ buffer: UnsafeRawPointer!, bufferSize size: Int32) {

  }
}

extension MainViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let str = dataSources.value[indexPath.row]
    let height = str.getHeight(maxWidth: 190, font: UIFont.systemFont(ofSize: 16.0))
    if height + 16 + 16 < 80 {
      return 80.0
    }
    return height + 16 + 16
  }
}


extension MainViewController {
  fileprivate func showMathView(withLatex latex: String?) {
    mathView.latex = latex
    view.addSubview(mathView)
    mathView.transform = CGAffineTransform.identity
    mathView.snp.makeConstraints({ [unowned self] in
      $0.bottom.equalTo(self.toolBarView!.snp.top)
      $0.left.right.equalTo(self.view)
      $0.height.equalTo(60)
    })
  }
}
