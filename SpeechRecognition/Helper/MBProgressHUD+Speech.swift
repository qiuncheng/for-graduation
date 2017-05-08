//
//  Speech.swift
//  SpeechRecognition
//
//  Created by yolo on 2017/4/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

protocol HUDAble {
}

extension HUDAble where Self: UIViewController {
  func showHUD(in view: UIView, title: String, duration: TimeInterval) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.animationType = .fade
    hud.mode = .customView
    hud.label.text = title
    hud.hide(animated: true, afterDelay: 0.75)
  }
  
  @discardableResult
  func showHUD(in view: UIView, title: String) -> MBProgressHUD {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.animationType = .fade
    hud.label.text = title
    return hud
  }
  
  @discardableResult
  func showProgress(in view: UIView) -> MBProgressHUD {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.animationType = .fade
    hud.mode = .indeterminate
    return hud
  }
}
