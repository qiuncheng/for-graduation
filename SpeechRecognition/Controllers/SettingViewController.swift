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
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
    }
    view.addSubview(tableView)
    
    tableView.do {
      $0.snp.makeConstraints({ [unowned self] (make) in
        make.edges.equalTo(self.view)
      })
    }
    
    inputWordObservable
      .asObservable()
      .bindTo(tableView.rx.items(cellIdentifier: "SettingCell", cellType: UITableViewCell.self))  { (row, element, cell) in
        cell.textLabel?.text = element
      }
      .addDisposableTo(disposeBag)
    
    tableView.rx
      .setDelegate(self)
      .addDisposableTo(disposeBag)
    
    tableView.rx
      .itemSelected
      .map({ [unowned self] indexPath in
        return (indexPath, self.inputWordObservable.value[indexPath.row])
      })
      .subscribe(onNext: { (indexPath, str) in
        if indexPath.section == 0 && indexPath.row == 0 {
          
        }
      })
      .addDisposableTo(disposeBag)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
