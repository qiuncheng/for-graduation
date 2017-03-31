//
//  Log.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

func Log<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
    print("\n----------------------")
    print("Log Time: \(Date().timeIntervalSince1970)" + "\nCurrent file : " + file + "\nCurrent function: " + function + "\nCurrent line :" + "\(line)" + "\nCurrent message: " + "\(message)")
    print("----------------------")
}
