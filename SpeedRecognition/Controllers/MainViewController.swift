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
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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

