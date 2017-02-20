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
    var borough: String?
    var coordinates: Coordinates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        self.view.backgroundColor = UIColor.white
        
        self.organizationNameLabel.text = socialService1?.organizationname
        self.descriptionLabel.text = socialService1?.description
        
//        APIRequestManager.shared.getDataForCoordinates(address: "31-00 47th Ave", borough: "queens") { (coordinates: [Coordinates]?) in
//            guard let validCoordinates = coordinates else { return }
//            dump(validCoordinates)
//        }
        
//        guard let validAddress = socialService1?.location_1_location else { return }
//        guard let validBorough = self.borough else { return }
//        
//        APIRequestManager.shared.getDataForCoordinates(address: validAddress, borough: validBorough) { (coordinatesArr: [Coordinates]?) in
//            guard let validCoordinatesArr = coordinatesArr else { return }
//            self.coordinates = validCoordinatesArr[0]
//            dump(validCoordinatesArr)
//        }
        
        //APIRequestManager.shared.getCoordinateFromGoogle(companyName: String, borough: String , complete: @escaping ([Coordinates]?) -> Void)
       
        
//        APIRequestManager.shared.getCoordinateFromGoogle(companyName: (self.socialService1?.organizationname)!, borough: self.borough!) { (coordinatesArr:[Coordinates]?) in
//            guard let validCoordinatesArr = coordinatesArr else { return }
//            guard validCoordinatesArr.count > 0 else { return }
//            self.coordinates = validCoordinatesArr[0]
//        }
        
        guard let validCoordinate = socialService1?.location_1 else { return }
        self.coordinates = validCoordinate
        
        if self.coordinates == nil {
            dump(self.coordinates)
            self.openInMapButton.isHidden = true
        }

    }
    
    private func setupViewHierarchy() {
        self.view.addSubview(organizationNameLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(openInMapButton)
    }
    
    func openInMap() {
        if let validCoordinates = self.coordinates {
            let socialServicesMapViewController = SocialServicesMapViewController()
            socialServicesMapViewController.coordinates = validCoordinates
            self.present(socialServicesMapViewController, animated: true, completion: nil)
        }
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
        button.addTarget(self, action: #selector(openInMap), for: .touchUpInside)
        return button
    }()
    
}
