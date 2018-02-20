//
//  ListView.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/17.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var _tableView: UITableView? {
        let tableView = UITableView.init(frame: self.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Key")
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(_tableView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Key")
        cell?.textLabel?.text = "hello"
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
