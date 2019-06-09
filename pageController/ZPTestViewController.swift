//
//  ZPTestViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/7.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPTestViewController: ZPPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
    }
    
    override func pageNumberOfChildController() -> NSInteger {
        
        return 2
    }
    
    override func pageChildControllerOfCurrent() -> UIViewController {
        
        let viewC = UIViewController()
        viewC.view.backgroundColor = UIColor.randomColor
        return viewC
    }
    
    override func pageChildControllerOfRect() -> CGRect {

        return CGRect(x: 0, y: 100, width: self.view.bounds.width, height: self.view.bounds.height - 64)
    }
    
    override func pageChildControllerScrollEnd(index: NSInteger) {
        
        print("index --------- \(index)")
    }
    
    override func pageChildControllerScrolling(scrollOffset: CGFloat) {
        
        print("scrollOffset = \(scrollOffset)")
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
