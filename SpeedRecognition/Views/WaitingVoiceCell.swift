//
//  WaitingVoiceCell.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/20.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class WaitingVoiceCell: UITableViewCell {

    fileprivate var avatarImageView: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
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
