//
//  MainViewController.swift
//  AutoLayout
//  我们去看花火吧!
//  Created by yuency on 14/09/2017.
//  Copyright © 2017 yuency. All rights reserved.
//

import UIKit

/// cell 重用标示
private let cellid = "MainViewController_CELL_ID"


class MainViewController: UIViewController {
    
    //MARK: - 属性组
    var tableView: UITableView!
    
    //MARK: - 在这里添加控制器的名字和列表要显示的名字
    let listArray = [
        ["MovingViewController": "假的无限滚动"],
        ["DropDownViewController": "下降"],
        ["WindCardViewController": "被风吹过的夏天"],
        ["ClockViewController": "时钟 \"外滩的旧钟声变没变\""],
        ["DoorYinViewController":"抖音♂︎"],
        ["EnergyViewController": "能量球"],
        ["WindowsXPViewController": "Windows XP"],
        ["MotionViewController": "物理效果"],
        ["ButtonsViewController":"按钮效果集合"],
        ["TextShineViewController": "Deep Dark Fantasies"],
        ["LineChartViewController":"我的月考成绩"],
        ["HexagonViewController":"分析我的KDA"],
        ["ParticleEffecViewController": "粒子效果"],
        ["NeonViewController": "散射粒子"],
        ["SnowViewController": "下雪了"],
        ["FireworksViewController": "打上花火"],
        ["QQShapViewController": "用手中的流沙画一个你呀"],
        ["BBViewController": "画图"],
        ]
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置页面
        setUpView()
    }
    
    
    /// 设置页面
    private func setUpView() {
        self.title = "啊你妹"
        
        tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        //注册 cell 重用的正确姿势
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
                
    }
}


// MARK: - 实现表格的协议方法
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: 数据源
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        
        //使用字典的值作为标题
        cell.textLabel?.text = "\(indexPath.row + 1) \(Array(listArray[indexPath.row].values)[0])"
        cell.textLabel?.textColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.00)
        return cell
    }
    
    //MARK: 事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //因为字典的 key 就是将要 push 进来的控制器的名字
        let vcName = Array(listArray[indexPath.row].keys)[0]
        
        //把这个 key 转换成为类 需要加上命名空间前缀,否则不生效
        if let cls = NSClassFromString(Bundle.main.nameSpaceStirng + "." + vcName) as? UIViewController.Type {
            let vc = cls.init()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}







