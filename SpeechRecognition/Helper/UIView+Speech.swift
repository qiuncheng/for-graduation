//
//  UIView+Speech.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/4/17.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension UIView {
  
  @discardableResult
  func with(cornerRadius radius: CGFloat) -> Self {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
    return self
  }
  
  @discardableResult
  func with(masksToBounds `is`: Bool) -> Self {
    self.layer.masksToBounds = `is`
    return self
  }
  
  func changeInputAccessoryView(height: CGFloat) {
    for constraint in self.constraints {
      if constraint.firstAttribute == NSLayoutAttribute.height {
        constraint.constant = height
        self.layoutIfNeeded()
        break
      }
    }
  }
}
