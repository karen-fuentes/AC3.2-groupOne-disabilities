//
//  SocialServicesDetailViewController.swift
//  HandyAccess
//
//  Created by Ana Ma on 2/19/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import SnapKit

class SocialServicesDetailViewController: UIViewController {
    
    var socialService1: SocialService1?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        self.view.backgroundColor = UIColor.white
        
        self.organizationNameLabel.text = socialService1?.organizationname
        self.descriptionLabel.text = socialService1?.description
    }
    
    private func setupViewHierarchy() {
        self.view.addSubview(organizationNameLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(openInMapButton)
    }
    
    private func configureConstraints() {
        organizationNameLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.topLayoutGuide.snp.bottom).offset(16)
            label.leading.equalToSuperview().offset(16)
            label.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.organizationNameLabel.snp.bottom).offset(16)
            label.leading.equalToSuperview().offset(16)
            label.trailing.equalToSuperview().inset(16)
        }
        
        openInMapButton.snp.makeConstraints { (button) in
            button.top.equalTo(self.descriptionLabel.snp.bottom).offset(16)
            button.centerX.equalToSuperview()
        }
    }
    
    lazy var organizationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Organization Name"
        label.font = UIFont.systemFont(ofSize: 20, weight: 8)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Organization Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: 6)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var openInMapButton: UIButton = {
        let button = UIButton()
        button.setTitle("Locate on Map", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        //<a href="https://icons8.com/web-app/30563/Map-Marker">
        button.imageView?.image = #imageLiteral(resourceName: "Map Marker-50")
        return button
    }()
    
}
