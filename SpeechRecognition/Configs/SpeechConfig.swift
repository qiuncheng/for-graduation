//
//  SpeechConfig.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/21.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

struct SpeechConfig {
    static let `default` =  SpeechConfig()
    
    var speechTimeOut: String = ""
    var vadEos: String = ""
    var vadBos: String = ""
    var language: String = ""
    var accent: String = ""
    var dot: String = ""
    var sampleRate: String = ""

    init() {
        speechTimeOut = "30000"
        vadEos = "30000"
        vadBos = "30000"
        dot = "1"
        sampleRate = "16000"
        language = "zh_cn"
        accent = "mandarin"
    }
    

}
