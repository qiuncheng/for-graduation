//
//  Dictionary+Speech.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/5/14.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation

extension Dictionary  {
//  func valid(withKey keyStr: String) -> Bool {
//    return
//  }
}

extension Dictionary where Value: Equatable {
  func allKeys(forValue val: Value) -> [Key] {
    return self.filter { $1 == val }.map { $0.0 }
  }
}
//let dict = ["a" : 1, "b" : 2, "c" : 1, "d" : 2]
//let keys = dict.allKeys(forValue: 1)
//print(keys) // [a, c]

infix operator -->
func -->(dict: Dictionary<String, [String]>, value: String) -> [String]? {
  return dict.filter({ $1.contains(value) }).map { $0.0 }
}
