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
    
    dismissButton = UIButton()
      .then({
        $0.setTitle("取消", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.setTitleColor(UIColor.gray, for: .highlighted)
      })
    addSubview(dismissButton)
    
    dismissButton.do({
      $0.snp.makeConstraints({
        $0.right.equalTo(-10)
        $0.top.equalTo(10)
      })
    })
  }
  
  private func setupMath(withLatex latex: String?) {
    guard let latex = latex else {
      return
    }
    let tempDict = CacheHelper.share.mathFormulaObject
//    tempDict.values.sorted(by: <#T##([String], [String]) -> Bool#>)
    let str = tempDict.values.filter { strs in
      return !strs.filter({ latex.contains($0) }).isEmpty
    }
    
    let strs = str.sorted { (strs0, strs1) -> Bool in
      let str0 = strs0.first!
      let str1 = strs1.first!
      return latex.range(of: str0)!.lowerBound < latex.range(of: str1)!.lowerBound
    }
    
    var latexes = ""
    for s in strs {
      let value = s.first!
      if let key = (tempDict --> value)?.first {
        if !latexes.contains(key) {
          latexes.append(key)
        }
      }
    }
    mathLabel.latex = latexes
  }
}
