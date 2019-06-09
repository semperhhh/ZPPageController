//
//  ZPPageViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/6.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ZPPageViewController: UIViewController {
    
    /// 滚动
    var scrollView = UIScrollView()
    
    /// 当前选中索引
    var selectIndex: NSInteger = 0
    
    /// frame缓存
    var cacheFrame = [NSInteger:CGRect]()
    
    /// 控制器缓存
    var cacheController = [NSInteger:UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 子控制器个数
        let numb = self.pageNumberOfChildController()
        let rect = self.pageChildControllerOfRect()
        self.scrollView = UIScrollView(frame: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height))
        
        for i in 0..<numb {
            let frame = CGRect(x: rect.size.width * CGFloat(i), y: 0, width: rect.size.width, height: rect.size.height)
            self.cacheFrame[i] = frame
        }
        self.scrollView.backgroundColor = UIColor.green
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        let wid = self.view.bounds.width * CGFloat(self.pageNumberOfChildController())
        self.scrollView.contentSize = CGSize(width: wid, height: rect.size.height)
        
        // 加载控制器
        self.addViewControllerAtIndex(index: self.selectIndex)
    }
    
    /// 有几个子控制器
    /// **子类必须实现
    /// - Returns: 子控制器个数
    public func pageNumberOfChildController() -> NSInteger {
        
        assert(false, "cannot pageNumberOfChildController")
    }
    
    /// 对应的每个控制器
    /// ** 子类必须实现
    /// - Returns: 当前子控制器
    public func pageChildControllerOfCurrent() -> UIViewController {
        
        assert(false,"cannot pageChildControllerOfCurrent")
    }
    
    /// 控件的尺寸
    /// ** 子类必须实现
    /// - Returns: 尺寸
    public func pageChildControllerOfRect() -> CGRect {
        
        assert(false, "cannot pageChildControllerOfRect")
    }
    
    /// 滚动停止时的选择
    ///
    /// - Returns: 选择的位置
    public func pageChildControllerScrollEnd(index: NSInteger) {
        // 子类需要可以覆盖
    }
    
    /// 滚动中的偏移
    ///
    /// - Parameter scrollOffset: 偏移的位置
    public func pageChildControllerScrolling(scrollOffset: CGFloat) {
        // 子类需要可以覆盖
    }
    
    /// 指定展示的视图位置
    public func pageChildControllerCurrentWithIndex(index: NSInteger) {
        
    }
    
    /// 移除上个控制器
    internal func removeChildController(index: NSInteger) {
        
        let controller = self.cacheController[index]
        controller?.removeFromParent()
        controller?.view.removeFromSuperview()
    }
    
    /// 加载viewcontroller
    internal func addViewControllerAtIndex(index: NSInteger) {
        
        //如果控制器大于总个数
        if index >= self.pageNumberOfChildController() {
            return
        }
        
        //对应的控制器
        let subController: UIViewController!
        
        if self.cacheController[index] != nil {
            subController = self.cacheController[index]
        }else {
            subController = self.pageChildControllerOfCurrent()
        }
        
        let frame = self.cacheFrame[index]
        subController.view.frame = frame!
        self.addChild(subController) //添加到视图上
        subController.didMove(toParent: self) //移动
        self.scrollView.addSubview(subController.view)
        
        //添加到缓存
        self.cacheController[index] = subController
    }
}

extension ZPPageViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x;
        
        self.pageChildControllerScrolling(scrollOffset: offsetX)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x;
        
        let index = offsetX / scrollView.bounds.width
        
        self.pageChildControllerScrollEnd(index: NSInteger(index))
        
        //移除上个控制器
        self.removeChildController(index: self.selectIndex)
        
        self.selectIndex = NSInteger(index)
        
        //添加子控制器
        self.addViewControllerAtIndex(index: self.selectIndex)
    }
}
