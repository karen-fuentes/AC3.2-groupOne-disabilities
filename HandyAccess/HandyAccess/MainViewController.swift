//
//  MainViewController.swift
//  HandyAccess
//
//  Created by Edward Anchundia on 2/18/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import SideMenu
import Mapbox

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sideMenu))
    }
    
    func sideMenu() {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }



}
