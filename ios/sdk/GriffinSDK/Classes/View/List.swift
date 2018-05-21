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
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Key")
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    var dataSource: [Any] = [Any]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(_tableView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Key")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Key")
        }
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

class List: DivView {
    
    private lazy var _listView: ListView? = {
        
        let listView = ListView.init(frame: CGRect.zero)
        
        return listView
    }()
    
    required init(ref: String, styles: Dictionary<String, Any>,props:Dictionary<String, Any>) {
        super.init(ref: ref, styles: styles, props: props)
        
    }
    
    override var view: UIView {
        return self._listView!
    }
}
