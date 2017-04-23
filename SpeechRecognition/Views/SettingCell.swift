//
//  SettingCell.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/4/16.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

class SettingCell: UITableViewCell, ViewIdentifierReuseable, HUDAble {
  var textField: UITextField?
  var titleLabel: UILabel?
  var openSwitch: UISwitch?
  
  var inputAccessView: WordInputView?
  
  let bag = DisposeBag()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setup()
  }
  
  fileprivate func setup() {
    textField = UITextField.init().with({ [weak self] in
      $0.tintColor = UIColor.clear
      $0.borderStyle = .none
      $0.placeholder = ""
      self?.inputAccessView = WordInputView()
      self?.inputAccessView?.updateFrame()
      $0.inputAccessoryView = self?.inputAccessView
      $0.with(masksToBounds: true)
    })
    
    addSubview(textField!)
    
    titleLabel = UILabel().with({
      $0.textColor = UIColor.init(hex: 0x232329)
      $0.sizeToFit()
    })
    addSubview(titleLabel!)
    
    openSwitch = UISwitch().with({
      $0.sizeToFit()
    })
    addSubview(openSwitch!)
    
    makeConstraints()
  }
  
  fileprivate func makeConstraints() {
    titleLabel?.snp.makeConstraints({
      $0.top.equalTo(self)
      $0.left.equalTo(self).offset(10)
      $0.bottom.equalTo(self)
    })
    
    textField?.snp.makeConstraints({ [unowned self] in
      $0.top.equalTo(self)
      $0.bottom.equalTo(self)
      $0.right.equalTo(self).offset(-10)
      $0.width.equalTo(1.0)
    })
    
    openSwitch?.do({
      $0.snp.makeConstraints({ [unowned self] in
        $0.right.equalTo(self.snp.right).offset(-8)
        $0.centerY.equalTo(self.snp.centerY)
      })
    })
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
