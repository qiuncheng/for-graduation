//
//  CacheHelper.swift
//  SpeechRecognition
//
//  Created by yolo on 2017/3/31.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import YYCache

struct CacheHelper {
  static let share = CacheHelper()
  
  init() {
    if let cacheFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
      cacheForMathFormula = YYDiskCache(path: cacheFilePath + "/cache_for_math_formula")
      cacheForMathFormula?.errorLogsEnabled = true
    }
    else {
      cacheForMathFormula = nil
    }
  }
  
  private(set) var cacheForMathFormula: YYDiskCache?
  
  var mathFormulaObject: Dictionary<String, [String]> {
    if let mathFormulaDict = CacheHelper.share.cacheForMathFormula?.object(forKey: CacheKey.cacheForMathFormulaKey) as? [String : [String]] {
      return mathFormulaDict
    }
    else {
      return [:]
    }
  }
  
  func updateMathFormula(withValue value: String, forKey key: String) {
    guard !value.isEmpty else {
      return
    }
    var temp = CacheHelper.share.mathFormulaObject
    if var tempArr = temp[key] {
      tempArr.append(value)
      temp.updateValue(tempArr, forKey: key)
      CacheHelper.share.cacheForMathFormula?.setObject(temp as NSCoding, forKey: CacheKey.cacheForMathFormulaKey)
    }
    else {
      let tempArr = [value]
      temp[key] = tempArr
      CacheHelper.share.cacheForMathFormula?.setObject(temp as NSCoding, forKey: CacheKey.cacheForMathFormulaKey)
    }
  }
  
  func updateMathFormula(withValues values: [String], forKey key: String) {
    guard !values.isEmpty else {
      return
    }
    var temp = CacheHelper.share.mathFormulaObject
    if var tempArr = temp[key] {
      tempArr.append(contentsOf: values)
      temp.updateValue(tempArr, forKey: key)
      CacheHelper.share.cacheForMathFormula?.setObject(temp as NSCoding, forKey: CacheKey.cacheForMathFormulaKey)
    }
    else {
      temp[key] = values
      CacheHelper.share.cacheForMathFormula?.setObject(temp as NSCoding, forKey: CacheKey.cacheForMathFormulaKey)
    }
  }
}
