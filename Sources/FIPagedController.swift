//
//  FIPagedViewController.swift
//  FIUI
//
//  Created by 白云飞 on 2019/2/19.
//  Copyright © 2019 白云飞. All rights reserved.
//

import UIKit
import SnapKit

open class FIPagedController: UIViewController {
    
    lazy open var contentView: UIView = {
        let view = UIView()
        scrollView.addSubview(view)
        return view
    }()
    
    /// Back content scrollView
    lazy open var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.bounces = false
        sv.delegate = self
        view.addSubview(sv)
        sv.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return sv
    }()
    
    open var viewControllers:[UIViewController]? {
        didSet {
            if let oldValue = oldValue {
                for (index, vc) in oldValue.enumerated() where vc.isViewLoaded {
                    removeViewController(for: index)
                }
            }
            if let viewControllers = viewControllers {
                let count = viewControllers.count
                if count > 0 {
                    contentView.snp.remakeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.top.bottom.equalTo(view)
                        make.width.equalTo(view).multipliedBy(count)
                    }
                }
            }
        }
    }
    
    /// The index of the selected viewController in `viewControllers`
    open var selectedIndex: Int {
        get { return _selectedIndex }
        set {
            _selectedIndex = newValue
        }
    }
    
    fileprivate var _selectedIndex: Int = 0 {
        didSet {
            self.delegate?.pagedController?(self, didMoveTo: _selectedIndex)
        }
    }
    
    weak open var delegate: FIPagedControllerDelegate?
    
    //MARK: - Life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        addViewController(for: selectedIndex)
    }
    
    //MARK: - Functions
    
    open func addViewController(for index: Int) {
        guard let viewControllers = viewControllers else {
            return
        }
        let toViewController = viewControllers[index]
        addChild(toViewController)
        contentView.addSubview(toViewController.view)
        toViewController.didMove(toParent: self)
        
        let proportion = CGFloat(index + 1) / CGFloat(viewControllers.count)
        toViewController.view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(view)
            make.right.equalTo(contentView.snp.right).multipliedBy(proportion)
        }
    }
    
    open func removeViewController(for index: Int) {
        guard let viewControllers = viewControllers else {
            return
        }
        let targetViewController = viewControllers[index]
        targetViewController.willMove(toParent: nil)
        targetViewController.view.removeFromSuperview()
        targetViewController.removeFromParent()
    }
}

extension FIPagedController: UIScrollViewDelegate {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            let pageWidth = scrollView.frame.width
            let offsetX = (scrollView.contentOffset.x - pageWidth * CGFloat(_selectedIndex))
            let progress = offsetX / pageWidth
            self.delegate?.pagedController?(self, movingTo: {
                let offset = progress > 0 ? ceil(progress) : floor(progress)
                let targetIndex = _selectedIndex + Int(offset)
                return targetIndex
            }(), with: progress)
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let targetIndex = Int(scrollView.contentOffset.x / pageWidth)
        if targetIndex == _selectedIndex {
            return
        }
        let toViewConntroller = viewControllers![targetIndex]
        if toViewConntroller.parent == nil {
            addViewController(for: targetIndex)
        }
        _selectedIndex = targetIndex
    }
}

@objc public protocol FIPagedControllerDelegate {
    
    @objc optional func pagedController(_ pagedController: FIPagedController, didMoveTo index: Int)
    
    @objc optional func pagedController(_ pagedController: FIPagedController, movingTo index: @autoclosure () -> Int, with progress: CGFloat)
}

public extension UIViewController {
    public var pagedController: FIPagedController? {
        if let parent = self.parent as? FIPagedController {
            return parent
        }
        return nil
    }
}
