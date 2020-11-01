//
//  ZPPageViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/6.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

protocol ZPHPageContentViewDelegate {

    /// 子控制器数量
    func pageNumberOfChildController() -> NSInteger

    /// 子控制器大小
    func pageChildControllerOfRect() -> CGRect

    /// 对应的控制器
    /// - Parameter index: 索引
    func pageChildControllerOfCurrent(index: NSInteger) -> UIViewController

    /// 滚动停止的位置
    /// - Parameter index: 索引
    func pageChildControllerScrollEnd(index: NSInteger)

    /// 滚动中的偏移
    func pageChildControllerScrolling(scrollOffset: CGFloat)
}

class ZPHPageViewController: UIViewController {

    var pageContentViewDelegate: ZPHPageContentViewDelegate?

    /// 滚动
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    /// 当前选中索引
    var selectIndex: NSInteger = 0

    /// 当前选中位置x
    private var selectOffsetx: CGFloat = 0

    /// 当前选中偏移位置
    private var selectPage: NSInteger = 0

    /// frame缓存
    private var cacheFrame = [NSInteger: CGRect]()

    /// 控制器缓存
    private var cacheController = [NSInteger: UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 子控制器个数
        let numb = pageContentViewDelegate?.pageNumberOfChildController() ?? 0
        let rect = pageContentViewDelegate?.pageChildControllerOfRect() ?? CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)

        scrollView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        view.addSubview(self.scrollView)
        for i in 0..<numb {
            let frame = CGRect(x: rect.size.width * CGFloat(i), y: 0, width: rect.size.width, height: rect.size.height)
            self.cacheFrame[i] = frame
        }

        let wid = self.view.bounds.width * CGFloat(numb)
        scrollView.contentSize = CGSize(width: wid, height: rect.size.height)

        // 加载控制器
        self.addViewControllerAtIndex(index: self.selectIndex)
    }

    /// 指定展示的视图位置
    /// 不可覆盖
    /// - Parameter index: 位置
    final func pageChildControllerCurrentWithIndex(index: NSInteger) {

        guard index < pageContentViewDelegate?.pageNumberOfChildController() ?? 0 else {
            return
        }

        self.removeChildController(index: self.selectIndex)

        self.addViewControllerAtIndex(index: index)

        let rect = self.view.frame
        self.scrollView.setContentOffset(CGPoint(x: rect.width * CGFloat(index), y: 0), animated: false)
        self.selectIndex = index
    }

    /// 移除上个控制器
    private func removeChildController(index: NSInteger) {

        let controller = self.cacheController[index]
        controller?.removeFromParent()
        controller?.view.removeFromSuperview()
    }

    /// 加载viewcontroller
    private func addViewControllerAtIndex(index: NSInteger) {

        // 如果控制器大于总个数
        if index >= pageContentViewDelegate?.pageNumberOfChildController() ?? 0 || index < 0 {
            return
        }

        // 对应的控制器
        let subController: UIViewController!

        if self.cacheController[index] != nil {
            subController = self.cacheController[index]
        } else {
            subController = pageContentViewDelegate?.pageChildControllerOfCurrent(index: index) ?? UIViewController()
            // 添加到缓存
            self.cacheController[index] = subController
        }

        print("flsfjlsfjlfsjfslfjls")

        let frame = self.cacheFrame[index]
        subController.view.frame = frame!
        self.addChild(subController) //添加到视图上
        subController.didMove(toParent: self) //移动
        self.scrollView.addSubview(subController.view)
    }
}

extension ZPHPageViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x

        pageContentViewDelegate?.pageChildControllerScrolling(scrollOffset: offsetX)

        var page: Float
        if offsetX > self.selectOffsetx {
            page = ceilf(Float(offsetX / scrollView.bounds.width))
        } else {
            page = floorf(Float(offsetX / scrollView.bounds.width))
        }

        self.selectOffsetx = offsetX

        if self.selectPage != NSInteger(page) {

            // 添加子控制器
            self.addViewControllerAtIndex(index: NSInteger(page))
            self.selectPage = NSInteger(page)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x
        let index = offsetX / scrollView.bounds.width

        pageContentViewDelegate?.pageChildControllerScrollEnd(index: NSInteger(index))

        if self.selectIndex == NSInteger(index) {
            return
        }

        // 移除上个控制器
        self.removeChildController(index: self.selectIndex)
        self.selectIndex = NSInteger(index)
    }
}
