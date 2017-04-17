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

class SettingCell: UITableViewCell, ViewIdentifierReuseable {
  var textField: UITextField?
  var titleLabel: UILabel?
  
  var inputAccessView: WordInputView?
  
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
    textField = UITextField.init().with({
      $0.tintColor = UIColor.clear
      $0.borderStyle = .none
      $0.placeholder = ""
      $0.isEnabled = false
      let view = WordInputView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
      view.backgroundColor = UIColor.red
      $0.inputAccessoryView = view
    })
    
    addSubview(textField!)
    
    titleLabel = UILabel().with({
      $0.textColor = UIColor.init(hex: 0x232329)
      $0.sizeToFit()
    })
    addSubview(titleLabel!)
    
    makeConstraints()
  }
  
  fileprivate func makeConstraints() {
    titleLabel?.snp.makeConstraints({
      $0.top.equalTo(self)
      $0.left.equalTo(self).offset(10)
      $0.bottom.equalTo(self)
    })
    
    textField?.snp.makeConstraints({ [unowned self] in
      $0.left.equalTo(self.titleLabel!.snp.left).offset(10)
      $0.top.equalTo(self)
      $0.bottom.equalTo(self)
      $0.right.equalTo(self).offset(-10)
    })
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
