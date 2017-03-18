//
//  ViewController.swift
//  SpeedRecognition
//
//  Created by yolo on 2017/3/13.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import DynamicColor
import SnapKit

class MainViewController: UIViewController {
    
    fileprivate weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hex: 0x232329)
        
        let tableView = UITableView().then({
            $0.delegate = self
            $0.dataSource = self
            
            $0.backgroundColor = UIColor.white
            $0.estimatedRowHeight = 88
            $0.registerCell(SpeedResultCell.self)
        })
        self.tableView = tableView
        view.addSubview(tableView)

        makeContraints()
    }
    
    fileprivate func makeContraints() {
        tableView?.snp.makeConstraints({ [unowned self] in
            $0.edges.equalTo(self.view)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath) as SpeedResultCell
        
        return cell
    }
}

