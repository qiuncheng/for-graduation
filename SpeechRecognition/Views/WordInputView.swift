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
import RxSwift
import RxCocoa

class WordInputView: UIView {
  
  var textView: UITextView?
  var senderButton: UIButton?
  var textHeightObservable = Variable(CGFloat())

  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  func updateFrame(withTextHeight height: CGFloat = 0) {
    var selfHeight: CGFloat = 0
    if 0 == height {
      selfHeight = 44.0
    }
    else {
      selfHeight = height + 22.0
    }
    frame = CGRect.init(x: 0, y: 0, width: UIScreen.screenWidth, height: selfHeight)
  }
  
  func setup() {
    self.backgroundColor = UIColor.lightGray.lighter()
    
    textView = UITextView().with({
      $0.textAlignment = .left
      $0.delegate = self
      $0.font = UIFont.systemFont(ofSize: 18.0)
      $0.with(cornerRadius: 2.0)
    })
    addSubview(textView!)
    
    textView?.do({
      $0.snp.makeConstraints({ (make) in
        make.left.equalTo(self.snp.left).offset(10)
        make.top.equalTo(self.snp.top).offset(8)
        make.bottom.equalTo(self.snp.bottom).offset(-8)
        make.right.equalTo(self.snp.right).offset(-60)
      })
    })
    
    senderButton = UIButton().with({
      $0.setTitle("上传", for: .normal)
      $0.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
      $0.setTitleColor(UIColor.white, for: .normal)
      $0.setTitleColor(UIColor.gray.lighter(), for: .highlighted)
      $0.setBackgroundImage(UIImage.image(withColor: UIColor.orange) ?? UIImage(), for: .normal)
      $0.setBackgroundImage(UIImage.image(withColor: UIColor.gray) ?? UIImage(), for: .highlighted)
      $0.sizeToFit()
      $0.with(cornerRadius: 5)
    })
    
    addSubview(senderButton!)
    
    senderButton?.do({
      $0.snp.makeConstraints({ [weak self] (make) in
        guard let _textView = self?.textView else { return }
        make.left.equalTo(_textView.snp.right).offset(8)
        make.bottom.equalTo(_textView.snp.bottom)
        make.width.equalTo(44)
        make.height.equalTo(28.0)
      })
    })
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    inputAccessoryView?.autoresizingMask = .flexibleHeight
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WordInputView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    let text = textView.text.trimmingCharacters(in: .whitespaces)
    let height = text.getHeight(maxWidth: UIScreen.screenWidth - 72, font: textView.font ?? UIFont.systemFont(ofSize: 18.0))
    textHeightObservable.value = height
  }
}
