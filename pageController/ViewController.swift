//
//  ViewController.swift
//  pageController
//
//  Created by zhangpenghui on 2019/6/6.
//  Copyright © 2019 zph. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let navi = UINavigationController(rootViewController: self)
    
        let application = UIApplication.shared.delegate as! AppDelegate
        application.window?.rootViewController = navi;
        
        self.title = "test"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let page = ZPTestViewController()
        self.navigationController?.pushViewController(page, animated: true)
    }
}

