//
//  UploaderManager.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/4/17.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class UploaderManager: NSObject {
  static let manager = UploaderManager()
  
  let name = "userword"
  
  var uploader: IFlyDataUploader
  
  var userwords: IFlyUserWords
  
  override init() {
    uploader = IFlyDataUploader()
    userwords = IFlyUserWords(json: "{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"科大讯飞\",\"云平台\",\"用户词条\",\"开始上传词条\",\"无语无用\"]}]}")
    
    super.init()
  }
  
  func setParameterForSubject(value: String) {
    uploader.setParameter(value, forKey: IFlySpeechConstant.subject())
  }
  
  func setParameterForDataType(value: String) {
    uploader.setParameter(value, forKey: IFlySpeechConstant.data_TYPE())
  }
  
}
