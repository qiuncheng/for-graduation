//
//  MathView.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/5/14.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import iosMath

class MathView: UIView {
  var latex: String? {
    didSet {
      setupMath()
    }
  }
  
  private func setupMath() {
    let tempDict = CacheHelper.share.mathFormulaObject
    let strs = tempDict.values.filter { [weak self] strs in
      guard let latex = self?.latex else {
        return false
      }
      return !strs.filter({ latex.contains($0) }).isEmpty
    }.first?.first
  }
}
