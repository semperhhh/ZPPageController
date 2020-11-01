//
//  ZPTestViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPTestViewController: UIViewController, ZPHPageContainerViewDelegate, ZPHPageContentViewDelegate {
    func pageNumberOfChildController() -> NSInteger {
        2
    }

    func pageChildControllerOfRect() -> CGRect {
        CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 400)
    }

    func pageChildControllerOfCurrent(index: NSInteger) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .randomColor
        return vc
    }

    func pageChildControllerScrollEnd(index: NSInteger) {
        container.pageSelectItem(index)
    }

    func pageChildControllerScrolling(scrollOffset: CGFloat) {

    }

    // MARK: container
    func pageContainerItemAction(_ index: Int) {
        contentViewController.pageChildControllerCurrentWithIndex(index: index)
    }

    func pageContainerItemsWidth(_ index: Int) -> CGFloat {
        if index == 0 {
            return 100
        } else {
            return 200
        }
    }
    
    var container : ZPHPageContainerView<ZPHPageContainerItem> = {
        let v = ZPHPageContainerView<ZPHPageContainerItem>()
        v.lineColor = UIColor.blue
        v.itemWidth = 88
        v.segmentItemList = [
            ZPHPageContainerItem("item1"),
            ZPHPageContainerItem("item2"),
            ZPHPageContainerItem("item3")
        ]
        return v
    }()

    lazy var contentViewController: ZPHPageViewController = {
        let v = ZPHPageViewController()
        v.pageContentViewDelegate = self
        return v
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

        container.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: 44)
        container.pageContainerDelegate = self
        view.addSubview(self.container)

        contentViewController.view.frame = CGRect(x: 0, y: 64 + 44, width: view.bounds.width, height: 600)
        contentViewController.view.backgroundColor = .randomColor
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
        view.addSubview(contentViewController.view)
    }
}

//随机颜色
extension UIColor {
    
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

class ZPHPageContainerItem: ZPHPageBaseItem {

    override var containerStatus: ZPHPageContainerStatus {
        didSet {
            if containerStatus == .select {
                nameLabel.textColor = .red
            }
            if containerStatus == .normal {
                nameLabel.textColor = .black
            }
        }
    }
    
    let nameLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lab.backgroundColor = UIColor.randomColor
        return lab
    }()
    
    init(_ title: String = "item") {
        super.init(frame: CGRect.zero)
        addSubview(nameLabel)
        nameLabel.text = title
    }
    
    override func layoutSubviews() {
        nameLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
