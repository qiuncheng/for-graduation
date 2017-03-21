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

class MainViewController: UIViewController {
  
  fileprivate weak var tableView: UITableView?
  fileprivate weak var toolBarView: ToolBarView?
  fileprivate weak var imageView: UIImageView?
  
  fileprivate var dataSources = [String]()
  
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
    title = "Speed Recognition"
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
      .then({
        $0.delegate = self
        $0.dataSource = self
        
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
      $0.backgroundColor = UIColor.init(hex: 0xeeeeeeee)
      $0.delegate = self
    })
    self.toolBarView = toolBarView
    view.addSubview(toolBarView)
    
    makeContraints()
    
    uploader = IFlyDataUploader()
    
    let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    if let cachePath = paths.first {
      pcmFilePath = cachePath + "/asr.pcm"
    }
    
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
extension MainViewController: ToolBarViewDelegate {
  func toolBarView(_ toolBarView: ToolBarView, speedButtonSelected sender: UIButton) {
    Log("")
    isRecording = !isRecording
    if isRecording { // 停止录音
      toolBarView.title = "停止录音"
      
    }
    else { // 开始录音
      toolBarView.title = "开始录音"
    }
  }
}

extension MainViewController: IFlySpeechRecognizerDelegate {
  func onResults(_ results: [Any]!, isLast: Bool) {
    
  }
  func onError(_ errorCode: IFlySpeechError!) {
    
  }
}

extension MainViewController: IFlyPcmRecorderDelegate {
    func onIFlyRecorderVolumeChanged(_ power: Int32) {
        
    }
    
    func onIFlyRecorderError(_ recoder: IFlyPcmRecorder!, theError error: Int32) {
        
    }
    
    func onIFlyRecorderBuffer(_ buffer: UnsafeRawPointer!, bufferSize size: Int32) {
        
    }
}

extension MainViewController: UITableViewDelegate {
  
}

extension MainViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(indexPath) as SpeedResultCell
    cell.contentText = "1234551474174017510848317894718978378175893104783184718987918790787587109789413788979ajfajfj9"
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
 
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let contentText = "1234551474174017510848317894718978378175893104783184718987918790787587109789413788979ajfajfj9"
    let height = contentText.getHeight(maxWidth: 190, font: UIFont.systemFont(ofSize: 16.0))
    return height + 16 + 16
  }
  
}

