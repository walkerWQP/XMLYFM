//
//  ClassifySubModuleType19Cell.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/19.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class ClassifySubModuleType19Cell: UICollectionViewCell {
    private var classifyModuleType19List:[ClassifyModuleType19List]?
    // 细线
    private var lineView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(r: 240, g: 240, b: 240)
        return view
    }()
    // 查看全部
    private lazy var moreBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("查看全部 >", for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        return button
    }()
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(150)
        }
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.width.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-40)
        }
        self.addSubview(self.moreBtn)
        self.moreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom).offset(5)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
    }
    
    var classifyVerticalModel: ClassifyVerticalModel? {
        didSet {
            guard let model = classifyVerticalModel else {return}
            self.classifyModuleType19List = model.list
            self.tableView.reloadData()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ClassifySubModuleType19Cell:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "play")
        cell.textLabel?.text = self.classifyModuleType19List?[indexPath.row].title
        return cell
    }
}
