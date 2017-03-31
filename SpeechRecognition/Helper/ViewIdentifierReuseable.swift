//
//  ViewIdentifierReuseable.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

protocol ViewIdentifierReuseable {

}

extension ViewIdentifierReuseable where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
