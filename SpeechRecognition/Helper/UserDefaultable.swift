//
//  UserDefaultable.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/4/23.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

protocol UserDefaultable {
}

extension UserDefaultable {
  private var `standard`: UserDefaults {
    return UserDefaults.standard
  }
  
  private var isOpenAudioStreamKey: String {
    return "SpeechRecognition.isOpenAudioStream.key"
  }
  
  var isOpenAudioStream: Bool {
    set {
      standard.set(newValue, forKey: isOpenAudioStreamKey)
      standard.synchronize()
    }
    
    get {
      return standard.bool(forKey: isOpenAudioStreamKey)
    }
  }
}

struct UserDefaultsManager: UserDefaultable {
  static let manager = UserDefaultsManager()
}
