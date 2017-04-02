//
//  ToolBarView.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/18.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import Then
import SnapKit

@objc protocol ToolBarViewDelegate: class {
    @objc
    optional func toolBarView(_ toolBarView: ToolBarView, speedButtonSelected sender: UIButton)
}

class ToolBarView: UIView {
    
    weak var button: UIButton?
    
    weak var delegate: ToolBarViewDelegate?
    
    var title: String = "开始录音" {
        didSet {
            button?.setTitle(title, for: .normal)
        }
    }
    var recordState = RecordState.unrecord
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let lineView = UIView().then({
            $0.backgroundColor = UIColor.darkGray
        })
        addSubview(lineView)
        
        lineView.snp.makeConstraints({ [unowned self] in
            $0.height.equalTo(0.5)
            $0.left.equalTo(self.snp.left)
            $0.right.equalTo(self.snp.right)
            $0.top.equalTo(self.snp.top)
        })
        
        let sureButton = UIButton().then({
            $0.layer.cornerRadius = 18
            $0.layer.masksToBounds = true
            $0.backgroundColor = UIColor.blue.lighter()
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.setTitleColor(UIColor.init(hex: 0xbbbb), for: .highlighted)
            $0.addTarget(self, action: #selector(speedButtonSelected(_:)), for: .touchUpInside)
        })
        button = sureButton
        
        addSubview(sureButton)
        sureButton.snp.makeConstraints({ [unowned self] in
            $0.left.equalTo(self.snp.left).offset(15)
            $0.height.equalTo(36)
            $0.right.equalTo(self.snp.right).offset(-15)
            $0.centerY.equalTo(self.snp.centerY)
        })
    }
    
    @objc fileprivate func speedButtonSelected(_ sender: UIButton) {
        if recordState == RecordState.unrecord {
            recordState = RecordState.recording
        }
        else {
            recordState = RecordState.unrecord
        }
        delegate?.toolBarView?(self, speedButtonSelected: sender)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
