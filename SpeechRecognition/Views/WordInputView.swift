//
//  WordInputView.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/4/17.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WordInputView: UIView {
  
  var textView: UITextView?
  var senderButton: UIButton?
  
  override func becomeFirstResponder() -> Bool {
    textView?.becomeFirstResponder()
    return super.becomeFirstResponder()
  }

  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  func setup() {
    textView = UITextView().with({
      $0.textAlignment = .left
      $0.delegate = self
    })
    addSubview(textView!)
    
    textView?.do({
      $0.snp.makeConstraints({ (make) in
        make.left.equalTo(self.snp.left).offset(10)
        make.top.equalTo(self.snp.top).offset(8)
        make.bottom.equalTo(self.snp.bottom).offset(-8)
        make.right.equalTo(self.snp.right).offset(-50)
      })
    })
    
    senderButton = UIButton().with({
      $0.backgroundColor = UIColor.blue
      $0.setTitle("确认", for: .normal)
      $0.sizeToFit()
    })
    addSubview(senderButton!)
    
    senderButton?.do({
      $0.snp.makeConstraints({ [weak self] (make) in
        guard let _textView = self?.textView else { return }
        make.left.equalTo(_textView.snp.right).offset(8)
        make.bottom.equalTo(_textView.snp.bottom)
      })
    })
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WordInputView: UITextViewDelegate {
  
}
