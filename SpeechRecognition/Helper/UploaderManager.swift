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
  
  var uploader: IFlyDataUploader
  
  override init() {
    uploader = IFlyDataUploader()
    super.init()
  }
  
  func setParameterForSubject(value: String) {
    uploader.setParameter(value, forKey: IFlySpeechConstant.subject())
  }
  
  func setParameterForDataType(value: String) {
    uploader.setParameter(value, forKey: IFlySpeechConstant.data_TYPE())
  }
  
}
