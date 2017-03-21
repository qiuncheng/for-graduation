//
//  UIAlertController+Speech.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/21.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(title: String? = nil,
                     message: String?,
                     preferredStyle style:UIAlertControllerStyle = .alert,
                     sureTitle sure: String? = "确定",
                     cancelTitle cancel: String? = "取消",
                     sureAction: Completion<UIAlertAction>? = nil,
                     cancelAction: Completion<UIAlertAction>? = nil) {
        
        self.init(title: title, message: message, preferredStyle: style)
        self.addAction(UIAlertAction.init(title: sure, style: .default, handler: sureAction))
        self.addAction(UIAlertAction.init(title: cancel, style: .cancel, handler: cancelAction))
        
    }
    
    func show(in viewController: UIViewController,
              completion: Completion<Void>? = nil) {
        viewController.present(self, animated: true, completion: completion)
    }
}
