//
//  TabBarController.swift
//  SnapchatCloneV3
//
//  Created by Anish Saha on 4/12/16.
//  Copyright © 2016 asaha. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.yellow
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
