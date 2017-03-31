//
//  String+Speed.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/20.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension String {
  func getHeight(maxWidth width: CGFloat, font: UIFont) -> CGFloat {
    return self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil).height
  }
  
  func getWidth(maxHeight height: CGFloat, font: UIFont) -> CGFloat {
    return self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil).width
  }
}
