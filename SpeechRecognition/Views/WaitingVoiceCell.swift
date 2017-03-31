//
//  WaitingVoiceCell.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/20.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class WaitingVoiceCell: UITableViewCell, ViewIdentifierReuseable {
  
  fileprivate let animationDuration = 3.0
  
  fileprivate var avatarImageView: UIImageView?
  fileprivate var redView: UIView?
  fileprivate var blueView: UIView?
  fileprivate var greenView: UIView?
  
  static var cellHeight: CGFloat {
    return 80.0
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.clear
    selectionStyle = .none
    initSubviews()
    
    startAnimation()
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
      make.right.equalTo(avatarImageView.snp.left).offset(-20)
      make.size.equalTo(15.0)
    }
    
    let blueView = UIView().then({
      $0.backgroundColor = UIColor(hex: 0x47d60c)
      $0.layer.cornerRadius = 7.5
      $0.layer.masksToBounds = true
    })
    addSubview(blueView)
    self.blueView = blueView
    blueView.snp.makeConstraints({ [unowned self] make in
      make.centerY.equalTo(self)
      make.size.equalTo(redView)
      make.right.equalTo(redView.snp.left).offset(-10)
    })
    
    let greenView = UIView().then({
      $0.backgroundColor = UIColor.init(hex: 0x60a942)
      $0.layer.masksToBounds = true
      $0.layer.cornerRadius = 7.5
    })
    
    addSubview(greenView)
    self.greenView = greenView
    greenView.snp.makeConstraints({ [unowned self] make in
      make.right.equalTo(blueView.snp.left).offset(-10)
      make.centerY.equalTo(self)
      make.size.equalTo(redView)
    })
  }
  
  func startAnimation() {
    let currentY = 40.0
    let keyframeAnimation = CAKeyframeAnimation().then {
      $0.keyPath = "position.y"
      $0.duration = self.animationDuration
      $0.keyTimes = [0.0, 0.2, 0.5, 0.80, 1.0]
      $0.values = [currentY, currentY - 7.5, currentY, currentY + 7.5, currentY]
      $0.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
      $0.timingFunctions = [
        CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
        CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut),
        CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault),
        CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn),
        CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
      ]
    }
    self.redView?.layer.add(keyframeAnimation, forKey: "red_view_key_frame_animation")
    let delay = self.animationDuration * 0.5
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { [weak self] in
      self?.blueView?.layer.add(keyframeAnimation, forKey: "blue_view_key_frame_animation")
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {  [weak self] in
        self?.greenView?.layer.add(keyframeAnimation, forKey: "green_view_key_frame_animation")
      }
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
