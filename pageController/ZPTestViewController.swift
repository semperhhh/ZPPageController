//
//  ZPTestViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPTestViewController: ZPPageViewController, ZPHPageContainerViewDelegate {
    
    func pageContainerItemsWidth(_ index: Int) -> [CGFloat] {
        return [200]
    }
    
    var container : ZPHPageContainerView<ZPHPageBaseItem> = {
        let v = ZPHPageContainerView()
        v.lineColor = UIColor.blue
        v.itemWidth = 88
        v.segmentItemList = [
            ZPHPageContainerItem("item1"),
            ZPHPageContainerItem("item2")
        ]
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

//        self.container.topViewAction = { labelTag in
//            self.pageChildControllerCurrentWithIndex(index: labelTag)
//        }
    }

    override func pageNumberOfChildController() -> NSInteger {

        return 5
    }
    
    override func pageChildControllerOfCurrent(index: NSInteger) -> UIViewController {
        
        let viewC = UIViewController()
        viewC.view.backgroundColor = UIColor.randomColor
        return viewC
    }
    
    override func pageChildControllerOfRect() -> CGRect {

        return CGRect(x: 0, y: 64 + 44, width: self.view.bounds.width, height: self.view.bounds.height - 64 - 44)
    }
    
    override func pageChildControllerScrollEnd(index: NSInteger) {
        
//        self.container.modalitySelect(index: index)
    }
    
    override func pageChildControllerScrolling(scrollOffset: CGFloat) {
        
//        self.container.modalityScroll(offset: scrollOffset)
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
