//
//  ViewController.swift
//  Demo
//
//  Created by 白云飞 on 2019/2/19.
//  Copyright © 2019 白云飞. All rights reserved.
//

import UIKit
import FIUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v1 = UIViewController()
        let v2 = UIViewController()
        v2.view.backgroundColor = UIColor.red
        let v3 = UIViewController()
        v3.view.backgroundColor = UIColor.yellow
        let v4 = UIViewController()
        v4.view.backgroundColor = UIColor.blue
        let vcs = [v1, v2, v3, v4]
        let root = FIPagedController()
        addChild(root)
        view.addSubview(root.view)
        root.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        root.didMove(toParent: self)
        root.viewControllers = vcs
    }


}

