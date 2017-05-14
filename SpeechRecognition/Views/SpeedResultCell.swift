//
//  SpeedResultCell.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/18.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import Then
import DynamicColor
import iosMath

class SpeedResultCell: UITableViewCell, ViewIdentifierReuseable {
  
  var contentText: String? {
    didSet {
      guard let content = contentText else {
        return
      }
      self.contentLabel?.latex = content
      let width = content.getWidth(maxHeight: 20, font: UIFont.systemFont(ofSize: 16))
      if width > 190 {
        let height = content.getHeight(maxWidth: 190, font: UIFont.systemFont(ofSize: 16))
        self.bgView?.snp.updateConstraints({
          $0.height.equalTo(height + 16 + 1)
        })
      }
      else {
        self.bgView?.snp.updateConstraints({
          $0.width.equalTo(width + 16 + 2)
        })
      }
    }
  }
  
  fileprivate weak var avatarImageView: UIImageView?
  var contentLabel: MTMathUILabel?
  fileprivate var bgView: UIView?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.clear
    selectionStyle = .none
    
    let avatarImageView    = UIImageView().then({
      $0.image               = #imageLiteral(resourceName: "assistant")
      $0.layer.cornerRadius  = 32.0
      $0.layer.masksToBounds = true
      $0.contentMode         = .scaleAspectFill
      $0.clipsToBounds       = true
    })
    addSubview(avatarImageView)
    self.avatarImageView = avatarImageView
    
    let bgView = UIView().then({
      $0.backgroundColor = UIColor.lightGray.lighter()
      $0.layer.cornerRadius = 20
      $0.layer.masksToBounds = true
    })
    addSubview(bgView)
    self.bgView = bgView
    
    let label = MTMathUILabel().then({
      $0.textAlignment = .left
      $0.textColor = UIColor(hex: 0x232329)
//      $0.font = UIFont.systemFont(ofSize: 16)
//      $0.numberOfLines = 0
    })
    addSubview(label)
    self.contentLabel = label
    
    makeContraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func makeContraints() {
    avatarImageView?.snp.makeConstraints({
      $0.left.equalTo(20)
      $0.top.equalTo(8)
      $0.size.equalTo(64)
    })
    
    bgView?.snp.makeConstraints({ [weak self] in
      guard let imageView = self?.avatarImageView else { return }
      $0.left.equalTo(imageView.snp.right).offset(20)
      $0.top.equalTo(imageView.snp.top)
      $0.width.equalTo(200)
      $0.height.equalTo(64.0)
    })
    
    contentLabel?.snp.makeConstraints({ [weak self] in 
      guard let bgView = self?.bgView else { return }
      $0.edges.equalTo(bgView).inset(UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8))
    })
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
