//
//  SettingViewController.swift
//  SpeechRecognition
//
//  Created by yolo on 2017/3/31.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SettingViewController: UIViewController, UITableViewDelegate, HUDAble, UserDefaultable {
  
  fileprivate weak var tableView: UITableView?
  fileprivate var inputWordObservable = Variable.init(["上传词表", "启用音频流识别"])
//  fileprivate var openSwitchObservable = Variable.init([])
  fileprivate let disposeBag = DisposeBag()
  let manager = UploaderManager.manager

  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    title = "设置"
    
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
      .then {
        $0.registerCell(SettingCell.self)
        $0.registerCell(OpenAudioStreamCell.self)
        $0.keyboardDismissMode = .onDrag
    }
    view.addSubview(tableView)
    
    self.tableView = tableView
    
    tableView.do {
      $0.snp.makeConstraints({ [unowned self] (make) in
        make.edges.equalTo(self.view)
      })
    }
    
    inputWordObservable
      .asObservable()
      .bindTo(tableView.rx.items(cellIdentifier: SettingCell.identifier, cellType: SettingCell.self))  { [unowned self] (row, element, cell) in
        cell.titleLabel?.text = element
        if row == 0 {
          cell.openSwitch?.isHidden = true
          cell.textField?.isHidden = false
        }
        else {
          cell.openSwitch?.isHidden = false
          cell.textField?.isHidden = true
          cell.openSwitch?.isOn = self.isOpenAudioStream
          cell.openSwitch?.rx.value
            .asObservable()
            .subscribe(onNext: { [weak self] currentValue in
              print(currentValue)
              self?.isOpenAudioStream = currentValue
            })
            .disposed(by: self.disposeBag)
        }
      }
      .disposed(by: disposeBag)
    
    manager.do({
      $0.setParameterForSubject(value: "iat")
      $0.setParameterForDataType(value: "userword")
    })
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    tableView.rx
      .itemSelected
      .map({ [unowned self] indexPath in
        return (indexPath, self.inputWordObservable.value[indexPath.row])
      })
      .subscribe(onNext: { [unowned self] (indexPath, str) in
        self.tableView?.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
          if let cell = self.tableView?.cellForRow(at: indexPath) as? SettingCell {
            cell.textField?.becomeFirstResponder()
            cell.inputAccessView?.textView?.becomeFirstResponder()
           
            let tapControl = cell.inputAccessView?.senderButton?.rx.tap
            tapControl?.asObservable()
                .map({ [weak cell] in
                    return cell?.inputAccessView?.textView?.text
                })
                .ifEmpty(default: "")
                .subscribe(onNext: { [weak self, weak cell] element in
                    guard let strongSelf = self else { return }
                    /// upload user word.
                  let hud = self?.showProgress(in: strongSelf.view)
                  strongSelf.manager.userwords.putWord("name", value: element ?? "")
                  self?.manager.uploader.uploadData(completionHandler: { (str, error) in
                    hud?.hide(animated: true)
                    self?.showHUD(in: strongSelf.view, title: "上传成功", duration: 1.0)
                    cell?.inputAccessView?.textView?.text = ""
                  }, name: strongSelf.manager.name, data: strongSelf.manager.userwords.toString())
                })
              .disposed(by: self.disposeBag)
          }
        }
      })
      .addDisposableTo(disposeBag)
  }
  
  deinit {
    print("setting view controller dealloced.")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
