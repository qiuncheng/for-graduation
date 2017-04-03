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

  func scrollTo(atRow row: Int, atSection section: Int = 0, _ scrollPosition: UITableViewScrollPosition) {
    let lastIndexPath = IndexPath(row: row, section: section)
    self.scrollToRow(at: lastIndexPath, at: scrollPosition, animated: true)
  }
}
