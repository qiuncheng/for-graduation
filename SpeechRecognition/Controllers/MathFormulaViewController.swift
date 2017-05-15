 //
//  MathFormulaViewController.swift
//  SpeechRecognition
//
//  Created by vsccw on 2017/5/15.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MathFormulaViewController: UITableViewController, HUDAble {
  
  @IBOutlet weak var mathTextField: UITextField!
  @IBOutlet weak var chineseTextField: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  
  fileprivate let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "数学公式映射"
    
    let mathTextValid = mathTextField.rx.text
      .map {
      !$0!.isEmpty
    }
    .shareReplay(1)
    
    let chineseTextValid = chineseTextField.rx.text
      .map {
        !$0!.isEmpty
      }
      .shareReplay(1)
    
    Observable
      .combineLatest(mathTextValid, chineseTextValid) {
        return $0 && $1
      }
      .bindTo(saveButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    saveButton.rx.tap
      .shareReplay(1)
      .map({ [unowned self] in
        return (self.mathTextField.text, self.chineseTextField.text)
      })
      .subscribe(onNext: { (mathText, chineseText) in
        CacheHelper.share.updateMathFormula(withValue: chineseText!, forKey: mathText!)
        self.showHUD(in: self.view, title: "已保存", duration: 1.0)
        self.view.endEditing(true)
      })
      .disposed(by: disposeBag)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
