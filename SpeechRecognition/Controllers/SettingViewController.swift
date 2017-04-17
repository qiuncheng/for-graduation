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

class SettingViewController: UIViewController, UITableViewDelegate {
  
  fileprivate weak var tableView: UITableView?
  fileprivate var inputWordObservable = Variable.init(["上传词表"])
  fileprivate let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    title = "设置"
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
      .then {
        $0.registerCell(SettingCell.self)
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
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    tableView.rx
      .itemSelected
      .map({ [unowned self] indexPath in
        return (indexPath, self.inputWordObservable.value[indexPath.row])
      })
      .subscribe(onNext: { [weak self] (indexPath, str) in
        if indexPath.section == 0 && indexPath.row == 0 {
          if let cell = self?.tableView?.cellForRow(at: indexPath) as? SettingCell {
            cell.textField?.isEnabled = true
            cell.textField?.becomeFirstResponder()
          }
        }
      })
      .addDisposableTo(disposeBag)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
