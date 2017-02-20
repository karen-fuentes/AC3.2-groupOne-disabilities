//
//  SocialServicesMapViewController.swift
//  HandyAccess
//
//  Created by Ana Ma on 2/19/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import Mapbox

class SocialServicesMapViewController: UIViewController, MGLMapViewDelegate/*, CLLocationManagerDelegate */{
    
    var socialService1: SocialService1!
    var coordinates: Coordinates! {
        didSet {
//            self.mapView = MGLMapView(frame: self.containerView.bounds)
//            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            
//            // Set the map’s center coordinate and zoom level.
//            
//            mapView.setCenter(CLLocationCoordinate2D(latitude: Double(Float(self.coordinates.lat)), longitude: Double(Float(self.coordinates.long))), zoomLevel: 12, animated: false)
//            view.addSubview(mapView)
//            
//            // Set the delegate property of our map view to `self` after instantiating it.
//            mapView.delegate = self
//            
//            // Declare the marker `hello` and set its coordinates, title, and subtitle.
//            //guard let validSocialServices1 = self.socialService1 else { return }
//            let location = MGLPointAnnotation()
//            location.coordinate = CLLocationCoordinate2D(latitude: Double(Float(self.coordinates.lat)), longitude: Double(Float(self.coordinates.long)))
//            guard let validSocialServices1 = self.socialService1 else { return }
//            location.title = "\(validSocialServices1.organizationname)"
//            location.subtitle = "\(validSocialServices1.description)"
//            
//            // Add marker `location` to the map.
//            mapView.addAnnotation(location)
//            
//            //Set the map’s center coordinate and zoom level.
//            //self.reloadInputViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        
        self.mapView = MGLMapView(frame: self.containerView.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(Float(self.coordinates.lat)), longitude: Double(Float(self.coordinates.long))), zoomLevel: 12, animated: false)
        self.containerView.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        //guard let validSocialServices1 = self.socialService1 else { return }
        let location = MGLPointAnnotation()
        location.coordinate = CLLocationCoordinate2D(latitude: Double(Float(self.coordinates.lat)), longitude: Double(Float(self.coordinates.long)))
        location.title = "No Organization Name"
        location.subtitle = "No Description"
        if let validSocialServices1 = self.socialService1 {
            location.title = validSocialServices1.organizationname
            location.subtitle = validSocialServices1.description
        }
        
        // Add marker `location` to the map.
        mapView.addAnnotation(location)
        
        //Set the map’s center coordinate and zoom level.
        //self.reloadInputViews()
        
//        let mapView = MGLMapView(frame: view.bounds)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        // Set the map’s center coordinate and zoom level.
//        
//        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(Float(self.coordinates.lat)), longitude: Double(Float(self.coordinates.long))), zoomLevel: 12, animated: false)
//        view.addSubview(mapView)
//        
//        // Set the delegate property of our map view to `self` after instantiating it.
//        mapView.delegate = self
//        
//        // Declare the marker `hello` and set its coordinates, title, and subtitle.
//        guard let validSocialServices1 = self.socialService1 else { return }
//        let location = MGLPointAnnotation()
//        location.coordinate = CLLocationCoordinate2D(latitude: Double(Float(self.coordinates.lat)), longitude: Double(Float(self.coordinates.long)))
//        location.title = "Organization Name"
//        location.subtitle = "\(validSocialServices1.organizationname)"
//        
//        // Add marker `location` to the map.
//        mapView.addAnnotation(location)
//        
//        //Set the map’s center coordinate and zoom level.
        
        

        
//        guard let validCoordinate = self.coordinates else { return }
//        let mapView = MGLMapView(frame: self.view.bounds)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.mapView.setCenter(CLLocationCoordinate2D(latitude: Double(validCoordinate.lat), longitude: Double(validCoordinate.long)), zoomLevel: 12, animated: true)
//        print("validCoordinate.lat\(validCoordinate.lat)")
//        print("validCoordinate.long\(validCoordinate.long)")
//        //self.edgesForExtendedLayout = []
//        self.view.addSubview(self.mapView)
//        mapView.delegate = self
        
        //locationManager.delegate = self
        //mapView.delegate = self
        
        //setUpMap()
    }
    
    private func setupViewHierarchy() {
        self.view.addSubview(self.containerView)
    }
    
    private func configureConstraints() {
        self.containerView.snp.makeConstraints { (view) in
            view.top.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.bottom.equalTo(self.bottomLayoutGuide.snp.top)
        }
    }
    
    func setUpMap() {
        guard let validCoordinate = self.coordinates else { return }
        //self.mapView.setCenter(CLLocationCoordinate2D(latitude: validCoordinate.lat, longitude: validCoordinate.long), zoomLevel: 12, animated: false)
        print("validCoordinate.lat\(validCoordinate.lat)")
        print("validCoordinate.long\(validCoordinate.long)")
        
        // Declare the marker `Organization Name` and set its coordinates, title, and subtitle.
        guard let validSocialServices1 = self.socialService1 else { return }
        let location = MGLPointAnnotation()
        location.coordinate = CLLocationCoordinate2D(latitude: validCoordinate.lat, longitude: validCoordinate.long)
        location.title = "Organization Name"
        location.subtitle = "\(validSocialServices1.organizationname)"
        
        // Add marker `location` to the map.
        self.mapView.addAnnotation(location)
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    internal var mapView: MGLMapView = {
        let mglMap = MGLMapView()
        return mglMap
    }()
    
    internal var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()

}
