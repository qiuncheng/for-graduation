//
//  WaitingVoiceCell.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/20.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class WaitingVoiceCell: UITableViewCell, ViewIdentifierReuseable {
  
  fileprivate var avatarImageView: UIImageView?
  fileprivate var redView: UIView?
  
  static var cellHeight: CGFloat {
    return 80.0
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.clear
    selectionStyle = .none
    initSubviews()
  }
  
  fileprivate func initSubviews() {
    
    let avatarImageView = UIImageView.init().then {
      $0.image = #imageLiteral(resourceName: "assistant")
      $0.layer.cornerRadius = 32.0
      $0.layer.masksToBounds = true
      $0.contentMode = .scaleAspectFill
    }
    addSubview(avatarImageView)
    avatarImageView.snp.makeConstraints({ [unowned self] make in
      make.right.equalTo(self.snp.right).offset(-10)
      make.size.equalTo(64.0)
      make.centerY.equalTo(self)
    })
    
    let redView = UIView().then {
      $0.backgroundColor = UIColor(hex: 0xd33535)
      $0.layer.cornerRadius = 7.5
      $0.layer.masksToBounds = true
    }
    addSubview(redView)
    self.redView = redView
    
    redView.snp.makeConstraints { [unowned self] make in
      make.centerY.equalTo(self.snp.centerY)
      make.right.equalTo(self.contentView.snp.right).offset(-100)
      make.size.equalTo(15.0)
    }
  }
  
  func startAnimation() {
    let keyframeAnimation = CAKeyframeAnimation(keyPath: "").then {
      $0.keyPath = "layer.position.y"
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
