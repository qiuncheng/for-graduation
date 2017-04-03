//
//  MainNavigationController.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/16.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import Then

class MainNavigationController: UINavigationController {
  
  convenience init() {
    let mainVC = MainViewController()
    self.init(rootViewController: mainVC)
    navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
  }
  
  override init(rootViewController: UIViewController) {
    super.init(
      rootViewController: rootViewController)
  }
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.tintColor = UIColor.black
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.backBarButtonItem?.title = ""
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
