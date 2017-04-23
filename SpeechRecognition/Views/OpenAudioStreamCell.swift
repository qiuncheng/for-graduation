//
//  OpenAudioStreamCell.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/4/20.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class OpenAudioStreamCell: UITableViewCell, ViewIdentifierReuseable {

  
  var titleLabel: UILabel?
  var openSwitch: UISwitch?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  fileprivate func setup() {
    titleLabel = UILabel.init().then({
      $0.textAlignment = .left
      $0.sizeToFit()
    })
    
    addSubview(titleLabel!)
    
    openSwitch = UISwitch().then({
      $0.sizeToFit()
    })
    addSubview(openSwitch!)
    
    makeConstraints()
  }
  
  fileprivate func makeConstraints() {
    titleLabel?.do({
      $0.snp.makeConstraints({ [unowned self] in
        $0.left.equalTo(self.snp.left).offset(8)
        $0.centerY.equalTo(self.snp.centerY)
        $0.width.equalTo(UIScreen.screenWidth - 68)
      })
    })
    
    openSwitch?.do({
      $0.snp.makeConstraints({
        $0.right.equalTo(self.snp.right).offset(-8)
        $0.centerY.equalTo(self.snp.centerY)
      })
    })
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
