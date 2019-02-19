//
//  FITabBar.swift
//  FIUI
//
//  Created by 白云飞 on 2019/2/20.
//  Copyright © 2019 白云飞. All rights reserved.
//

import UIKit

public enum FITabBarItemArrangement {
    case equalWidth
    case equalSpacing(CGFloat)
    // When you touched extra item, which would not trigger changing selected index
    case equalWidthWithExtraView(UIView, index: Int)
}

open class FITabBar: UIView {
    
    open var items: [UIView]?
    
    open var selectedIndex = 0
    
    open var itemArrangement: FITabBarItemArrangement = .equalWidth
    
    weak open var delegate: FITabBarDelegate?
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let gst = UITapGestureRecognizer()
        gst.numberOfTapsRequired = 1
        gst.numberOfTouchesRequired = 1
        gst.addTarget(self, action: #selector(tapped))
        return gst
    }()

    //MARK: - Life cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addGestureRecognizer(tapGesture)
        if let items = items {
            addItems(items)
        }
    }
    
    private func addItems(_ items: [UIView]) {
        var items = items
        switch itemArrangement {
        case .equalWidthWithExtraView(let view, let index):
            items.insert(view, at: index)
            fallthrough
        case .equalWidth:
            let count = items.count
            for (index, item) in items.enumerated() {
                item.alpha = 0.6
                addSubview(item)
                item.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.width.equalToSuperview().dividedBy(count)
                    make.right.equalTo(self.snp.right).multipliedBy(CGFloat(index+1)/CGFloat(count))
                }
            }
        case .equalSpacing(let spacing):
            //TODO: add
            break
        }
        
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if let items = items {
            for (index, item) in items.enumerated() {
                if item.frame.contains(location) {
                    let repeated = selectedIndex == index
                    self.delegate?.tabBar?(self, didSelect: item, at: index, repeated: repeated)
                    return
                }
            }
            switch itemArrangement {
            case .equalWidthWithExtraView(let item, _):
                if item.frame.contains(location) {
                    self.delegate?.tabBar?(self, didSelectExtra: item)
                }
            default:
                break
            }
        }
    }
}

@objc public protocol FITabBarDelegate {
    @objc optional func tabBar(_ tabBar: FITabBar, didSelect item: UIView, at index: Int, repeated: Bool)
    @objc optional func tabBar(_ tabBar: FITabBar, didSelectExtra Item: UIView)
}
