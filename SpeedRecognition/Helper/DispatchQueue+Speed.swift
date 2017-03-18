//
//  DispatchQueue+Speed.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/18.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension DispatchQueue {
    class func safeMainQueue(block: @escaping (Void) -> Void) {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
