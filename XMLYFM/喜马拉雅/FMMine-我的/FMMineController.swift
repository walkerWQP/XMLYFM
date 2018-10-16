//
//  FMMineController.swift
//  XMLYFM
//
//  Created by Domo on 2018/7/30.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit
let kNavBarBottom = WRNavigationBar.navBarBottom()

class FMMineController: UIViewController {
    private let FMMineMakeCellID = "FMMineMakeCell"
    private let FMMineShopCellID = "FMMineShopCell"
    
    private lazy var dataSource: Array = {
        return [[["icon":"钱数", "title": "分享赚钱"],
                 ["icon":"沙漏", "title": "免流量服务"]],
                
                [["icon":"扫一扫", "title": "扫一扫"],
                 ["icon":"月亮", "title": "夜间模式"]],
                
                [["icon":"意见反馈", "title": "帮助与反馈"]]]
    }()
    
    
    // 懒加载顶部头视图
    private lazy var headerView:FMMineHeaderView = {
        let view = FMMineHeaderView.init(frame: CGRect(x:0, y:0, width:YYScreenWidth, height: 300))
        view.delegate = self
        return view
    }()
    // 懒加载TableView
    private lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame:CGRect(x:0, y:0, width:YYScreenWidth, height:YYScreenHeigth), style: UITableViewStyle.plain)
        tableView.contentInset = UIEdgeInsetsMake(-CGFloat(kNavBarBottom), 0, 0, 0);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = FooterViewColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(FMMineMakeCell.self, forCellReuseIdentifier: FMMineMakeCellID)
        tableView.tableHeaderView = headerView
        return tableView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.headerView.stopAnimationViewAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.wr_viewWillAppear(animated)
        self.headerView.setAnimationViewAnimation()
    }
    
    //Mark: - 导航栏左边按钮
    private lazy var leftBarButton:UIButton = {
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "msg"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(leftBarButtonClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    //Mark: - 导航栏右边按钮
    private lazy var rightBarButton:UIButton = {
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x:0, y:0, width:30, height: 30)
        button.setImage(UIImage(named: "set"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(rightBarButtonClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏颜色
        navBarBarTintColor = UIColor.init(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
        // 设置初始导航栏透明度
        self.navBarBackgroundAlpha = 0
        self.navigationItem.title = " "
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        
        // 导航栏左右item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
    }
    
    //Mark: - 导航栏左边消息点击事件
    @objc func leftBarButtonClick() {
        
    }
    //Mark: - 导航栏右边设置点击事件
    @objc func rightBarButtonClick() {
        let setVC = MineSetController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
}



// Mark: -TableView Delegate
extension FMMineController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 100
        }else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if indexPath.section == 0 {
            let cell:FMMineMakeCell = tableView.dequeueReusableCell(withIdentifier: FMMineMakeCellID, for: indexPath) as! FMMineMakeCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            let sectionArray = dataSource[indexPath.section-1]
            let dict: [String: String] = sectionArray[indexPath.row]
            cell.imageView?.image =  UIImage(named: dict["icon"] ?? "")
            cell.textLabel?.text = dict["title"]
            if indexPath.section == 3 && indexPath.row == 1{
                let cellSwitch = UISwitch.init()
                cell.accessoryView = cellSwitch
            }else {
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = FooterViewColor
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = FooterViewColor
        return headerView
    }
    
//    // 控制向上滚动显示导航栏标题和左右按钮
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY > 0)
        {
            let alpha = offsetY / CGFloat(kNavBarBottom)
            navBarBackgroundAlpha = alpha
//            self.headerView.msgBtn.isHidden = true
//            self.headerView.setBtn.isHidden = true
//            self.leftBarButton.isHidden = false
//            self.rightBarButton.isHidden = false
            print("lala")
        }else{
            navBarBackgroundAlpha = 0
//            self.headerView.msgBtn.isHidden = false
//            self.headerView.setBtn.isHidden = false
//            self.leftBarButton.isHidden = true
//            self.rightBarButton.isHidden = true
            print("zhege")
        }
    }
}

/// 首页视图左消息，右设置 按钮点击代理方法
extension FMMineController : FMMineHeaderViewDelegate {
//    func msgBtnClick() {
//        
//    }
//    
//    func setBtnClick() {
//        let setVC = MineSetController()
//        self.navigationController?.pushViewController(setVC, animated: true)
//    }
    
    func shopBtnClick(tag:Int) {
        
    }
}








