//
//  TableViewCell.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/18.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ T: T.Type) where T: ViewIdentifierReuseable{
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T where T: ViewIdentifierReuseable {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
}
