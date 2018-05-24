//
//  ListView.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/17.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class GnDataSource {
    
    var height: CGFloat = 0
    var rawValue: Any?
    var tag: String = ""
    
    var component: ViewComponent?
}


class ListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var _tableView: UITableView? {
        let tableView = UITableView.init(frame: self.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }
    
    private var _dataSource: [GnDataSource] = [GnDataSource]()
    
    var dataSource:[GnDataSource] {
        get {
            return _dataSource
        }
        set {
            _dataSource = newValue
            
            _tableView?.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(_tableView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: item.tag)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: item.tag)
            cell?.contentView.addSubview((dataSource[indexPath.row].component?.view)!)
        }
   
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

class List: DivView {
    
    private lazy var _listView: ListView = {
        
        let listView = ListView.init(frame: CGRect.zero)
        
        return listView
    }()
    
    override var view: UIView {
        return self._listView
    }
    
    private var _listData: Array<[String:Any]> = []
    private var listData: Array<[String:Any]> {
        get {
            return _listData
        }
        set {
            _listData = newValue
        }
    }
    
    private var _listItem: String = ""
    
    required init(ref: String, styles: Dictionary<String, Any>,props:Dictionary<String, Any>) {
        super.init(ref: ref, styles: styles, props: props)
        
    }
    
    override func updateProps(_ props: Dictionary<String, Any>) {
        super.updateProps(props)
        
        if let listData = props.toArray(key: "listData") {
            self.listData = listData as! Array<[String : Any]>
        }
        if let listItem = props.toString(key: "listItem") {
            self._listItem = listItem
        }
    }
    
    private var _cells:[Row] = [Row]()
    
    override func addChildren(_ children: [ViewComponent?]) {
        for item in children {
            _cells.append(item as! Row)
        }
    }
    
    override func addChild(_ child: ViewComponent) {
        
    }
    
    override func layoutFinish() {
        super.layoutFinish()
        
        _listView.backgroundColor = UIColor.red
        _listView.dataSource = _listData.map { (item) -> GnDataSource in
            let dataSource = GnDataSource()
            dataSource.height = 100
            dataSource.tag = item["tag"] as! String
            dataSource.rawValue = item
            dataSource.component = _cells.filter({ (rowItem) -> Bool in
                return rowItem.tag == (item["tag"] as! String)
            }).first
            
            return dataSource
        }
    }
}


class Row: DivView {
    
    private lazy var _row: UITableViewCell? = {
        
        let row = UITableViewCell.init(frame: CGRect.zero)
        
        return row
    }()
    
    override var view: UIView {
        return self._row!
    }
    
    private var _tag: String?
    
    var tag: String {
        return _tag ?? ""
    }
    
    required init(ref: String, styles: Dictionary<String, Any>,props:Dictionary<String, Any>) {
        super.init(ref: ref, styles: styles, props: props)
        
    }
    
    override func updateProps(_ props: Dictionary<String, Any>) {
        super.updateProps(props)
        
        if let tag = props.toString(key: "tag") {
            self._tag = tag
        }
    }
    
    
}
