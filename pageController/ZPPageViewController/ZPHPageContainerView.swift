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
protocol ZPHPageContainerProtocol {
    var containerStatus: ZPHPageContainerStatus { get set }
}

/// 遵守协议的item
class ZPHPageBaseItem: UIView, ZPHPageContainerProtocol {
    var containerStatus: ZPHPageContainerStatus = .normal
}

class ZPHPageContainerItem: ZPHPageBaseItem {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.randomColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ZPHPageContainerView<T: ZPHPageBaseItem>: UIView {

    /// item宽
    var itemWidth: CGFloat = 64
    /// 线宽
    var lineWidth: CGFloat = 40
    /// 线高
    var lineHeight: CGFloat = 3
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
                self.addSubview(item)
            }
        }
    }

    @objc func tapAction(_ tap: UIGestureRecognizer) {

        guard let view: T = tap.view as? T else {
            return
        }

        guard view != currentItem else {// 重复点击无效
            return
        }
        currentItem?.containerStatus = .normal
        view.containerStatus = .select
        currentItem = view
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.lineView.frame = CGRect(x: ((self.itemWidth - self.lineWidth) / 2) + (self.itemWidth * CGFloat(view.tag)),
                                     y: self.bounds.height - self.lineHeight,
                                     width: self.lineWidth,
                                     height: self.lineHeight)
        }
        topViewAction(view.tag)
    }

    override func layoutSubviews() {

        print("layoutSubviews")

        var start: CGFloat = 0
        for item in segmentItemList {
            item.frame = CGRect(x: start, y: 0, width: itemWidth, height: self.bounds.height)
            if item.containerStatus == .select {
                currentItem = item
                lineView.frame = CGRect(x: (itemWidth - lineWidth) / 2 + start,
                                    y: self.bounds.height - lineHeight,
                                    width: lineWidth,
                                    height: lineHeight)
            }
            start += itemWidth
        }
    }

    /// 样式
    var modality: ZPPageContainerModality!

    /// 下划线
    lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.randomColor
        return v
    }()

    /// 当前选中的item
    var currentItem: T?

    /// 点击回调
    var topViewAction: ((NSInteger) -> Void)!

}

class ZPPageContainerModality: NSObject {

    /// 未选中的颜色,默认灰色
    var normalColor: UIColor = UIColor.gray
    /// 选中的颜色,默认绿色
    var selectColor: UIColor = UIColor.green
    /// 线条选择器尺寸,默认 40 2
    var lineContainerSize: CGSize?
    /// 是否展示线条选择器,默认false
    var isHaveLineContainer: Bool = false
}
