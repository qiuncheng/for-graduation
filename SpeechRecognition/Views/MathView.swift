//
//  MathView.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/5/14.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import iosMath

class MathView: UIView {
  
  fileprivate var mathLabel: MTMathUILabel!
  fileprivate var dismissButton: UIButton!
  fileprivate let disposeBag = DisposeBag()
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.lightGray.lighter()
    setupSubviews()
    
    dismissButton.rx.tap
      .shareReplay(1)
      .subscribe(onNext: {
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
          self?.transform = CGAffineTransform(translationX: UIScreen.screenWidth, y: 0)
          }, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
      })
      .disposed(by: disposeBag)
    
  }
  
  
  var latex: String? {
    didSet {
      setupMath(withLatex: latex)
    }
  }
  
  private func setupSubviews() {
    mathLabel = MTMathUILabel()
      .then({
        $0.fontSize = 20.0
        $0.textColor = UIColor.black
      })
    addSubview(mathLabel)
    
    mathLabel.do({
      $0.snp.makeConstraints({ [unowned self] in
        $0.edges.equalTo(self).offset(10)
      })
    })
    
    dismissButton = UIButton(type: .system)
      .then({
        $0.setImage(#imageLiteral(resourceName: "dismissButton"), for: .normal)
        $0.contentMode = .scaleToFill
        $0.tintColor = UIColor.black
      })
    addSubview(dismissButton)
    
    dismissButton.do({
      $0.snp.makeConstraints({
        $0.right.equalTo(-10)
        $0.top.equalTo(5)
        $0.size.equalTo(20)
      })
    })
  }
  
  private func setupMath(withLatex latex: String?) {
    guard let latex = latex else {
      return
    }
    let tempDict = CacheHelper.share.mathFormulaObject
    var values = [String]()
    tempDict.values.forEach {
      values.append(contentsOf: $0)
    }
    values = values.sorted { (str1, str2) -> Bool in
      return str1.characters.count > str2.characters.count
    }
    
    var tempLatex = latex
    let str = values.filter {
      let result = tempLatex.contains($0)
      if result,
        let range = tempLatex.range(of: $0) {
        tempLatex.removeSubrange(range)
      }
      return result
    }
    
    guard str.count > 0 else {
      return
    }
    
    let strs = str.sorted { (str0, str1) -> Bool in
      return latex.range(of: str0)!.lowerBound < latex.range(of: str1)!.lowerBound
    }
    
    var latexes = ""
    for value in strs {
      if let key = (tempDict --> value)?.first {
        if !latexes.contains(key) {
          latexes.append(key)
        }
      }
    }
    mathLabel.latex = latexes
  }
}
