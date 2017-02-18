//
//  ButtonViewController.swift
//  HandyAccess
//
//  Created by Edward Anchundia on 2/18/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        setupViewHierarchy()
        setupView()
    }
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(button3)
    }
    
    func setupView() {
        button2.snp.makeConstraints({ (view) in
            view.bottom.equalTo()
        })
        
        button3.snp.makeConstraints({ (view) in
            view.center.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.5)
            view.height.equalTo(70)
        })
    }
    
    

    internal var button1: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        button.backgroundColor = UIColor.darkGray
        return button
    }()
    
    internal var button2: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        return button
    }()
    
    internal var button3: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        return button
    }()
    
    internal var button4: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        return button
    }()
    
    internal var button5: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        return button
    }()
    
}
