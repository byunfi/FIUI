//
//  FITabBarController.swift
//  FIUI
//
//  Created by 白云飞 on 2019/2/20.
//  Copyright © 2019 白云飞. All rights reserved.
//

import UIKit
import SnapKit

open class FITabBarController: FIPagedController {
    
    open var barHeight: CGFloat = 40
    
    lazy open var tabBar: FITabBar = {
        let bar = FITabBar()
        view.addSubview(bar)
        bar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(barHeight)
        }
        return bar
    }()
    

    override open func viewDidLoad() {
        super.viewDidLoad()

    }
}

