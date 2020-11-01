//
//  ZPPageContainerView.swift
//  pageController
//
//  Created by zph on 2019/6/10.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

/// status
enum ZPHPageContainerStatus {
    case normal, select
}

/// protocol, have status
fileprivate protocol ZPHPageContainerProtocol {
    var containerStatus: ZPHPageContainerStatus { get set }
}

/// 遵守协议的item
class ZPHPageBaseItem: UIView, ZPHPageContainerProtocol {
    var containerStatus: ZPHPageContainerStatus = .normal
}

@objc protocol ZPHPageContainerViewDelegate {
    /// 分页的item的宽
    /// - Parameter index: index
    @objc optional func pageContainerItemsWidth(_ index: Int) -> CGFloat
    /// 分页点击
    /// - Parameter index: index
    func pageContainerItemAction(_ index: Int)
}

class ZPHPageContainerView<T: ZPHPageBaseItem>: UIView {
    
    var pageContainerDelegate: ZPHPageContainerViewDelegate?
    
    /// item宽
    var itemWidth: CGFloat = 64
    /// 线宽
    var lineWidth: CGFloat = 40
    /// 线高
    var lineHeight: CGFloat = 3 {
        didSet {
            lineView.layer.cornerRadius = lineHeight / 2
        }
    }
    /// 线的颜色
    var lineColor: UIColor = #colorLiteral(red: 0.1174837574, green: 0.6798678637, blue: 0.456895709, alpha: 1) {
        didSet {
            lineView.backgroundColor = lineColor
        }
    }
    /// 线条隐藏
    var lineHidden: Bool = false {
        didSet {
            lineView.isHidden = lineHidden
        }
    }

    /// 下划线
    private lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = lineColor
        v.layer.cornerRadius = lineHeight / 2
        return v
    }()

    /// 当前选中的item
    private var currentItem: T? {
        didSet {
            oldValue?.containerStatus = .normal
            currentItem!.containerStatus = .select
            if oldValue != nil {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                    self.lineView.frame = CGRect(x: ((self.currentItem!.bounds.width - self.lineWidth) / 2) + self.currentItem!.frame.origin.x,
                                                 y: self.bounds.height - self.lineHeight,
                                                 width: self.lineWidth,
                                                 height: self.lineHeight)
                }
            }
        }
    }

    /// 数组
    var segmentItemList: [T] = [] {
        didSet {
            guard !segmentItemList.isEmpty else {
                return
            }
            for i in 0 ..< segmentItemList.count {
                let item: T = segmentItemList[i]
                item.tag = i
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
                item.addGestureRecognizer(tap)
                addSubview(item)
                if i == 0 {
                    currentItem = item
                }
            }
            
            addSubview(lineView)
        }
    }

    @objc private func tapAction(_ tap: UIGestureRecognizer) {

        guard let view: T = tap.view as? T else {
            return
        }
        guard view != currentItem else {// 重复点击无效
            return
        }
        currentItem = view
        pageContainerDelegate?.pageContainerItemAction(view.tag)
    }

    /// 选择item
    /// - Parameter index: 位置
    func pageSelectItem(_ index: Int) {
        guard index < segmentItemList.count else {
            return
        }
        currentItem = segmentItemList[index]
    }
    
    override func layoutSubviews() {
        
        var start: CGFloat = 0
        for (i, item) in segmentItemList.enumerated() {
            let itemW: CGFloat = pageContainerDelegate?.pageContainerItemsWidth?(i) ?? itemWidth
            item.frame = CGRect(x: start,
                                y: 0,
                                width: itemW,
                                height: self.bounds.height)
            if i == 0 {
                lineView.frame = CGRect(x: (itemW - lineWidth) / 2,
                                        y: self.bounds.height - lineHeight,
                                        width: lineWidth,
                                        height: lineHeight)
            }
            start += itemW
        }
    }
}

struct ZPHPageContainerModality {

    var itemWidth: CGFloat = 64
    /// 线条选择器尺寸,默认 40 2
    var lineContainerSize: CGSize = CGSize(width: 40, height: 3)
    /// 是否展示线条选择器,默认false
    var isHaveLineContainer: Bool = false
}
