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

class SettingViewController: UIViewController, UITableViewDelegate, HUDAble {
  
  fileprivate weak var tableView: UITableView?
  fileprivate var inputWordObservable = Variable.init(["上传词表"])
  fileprivate let disposeBag = DisposeBag()
  let manager = UploaderManager.manager

  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    title = "设置"
    
    
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
      .then {
        $0.registerCell(SettingCell.self)
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
      .bindTo(tableView.rx.items(cellIdentifier: SettingCell.identifier, cellType: SettingCell.self))  { (row, element, cell) in
        cell.titleLabel?.text = element
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
           
            let tapControl = cell.inputAccessView?.senderButton?.rx.tap
            tapControl?.asObservable()
              .map({ [weak cell] in
                return cell?.inputAccessView?.textView?.text
              })
              .ifEmpty(default: "")
              .subscribe(onNext: { [weak self] element in
                guard let strongSelf = self else { return }
                /// upload user word.
                strongSelf.manager.userwords.putWord("name", value: element ?? "")
                self?.manager.uploader.uploadData(completionHandler: { (str, error) in
                  
                  self?.showHUD(in: strongSelf.view, title: "上传成功", duration: 1.0)
                }, name: strongSelf.manager.name, data: strongSelf.manager.userwords.toString())
              })
              .disposed(by: self.disposeBag)
          }
        }
      })
      .addDisposableTo(disposeBag)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
