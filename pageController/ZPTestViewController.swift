//
//  ZPTestViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPTestViewController: ZPPageViewController {
    
    var container : ZPHPageContainerView<ZPHPageBaseItem> = {
        let v = ZPHPageContainerView()
        v.backgroundColor = UIColor.randomColor
        v.segmentItemList = [
            ZPHPageContainerItem(),
            ZPHPageContainerItem()
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

        container.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: 64)
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
