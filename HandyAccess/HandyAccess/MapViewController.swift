//
//  MapViewController.swift
//  HandyAccess
//
//  Created by Karen Fuentes on 2/17/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    var annotations = [MGLAnnotation]()
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locMan.distanceFilter = 50.0
        return locMan
    }()
    let geocoder: CLGeocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .cyan
        
        setupViewHierarchy()
        setupView()
        
        locationManager.delegate = self
        mapView.delegate = self
    }
    
    
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        view.addSubview(mapView)


        // Do any additional setup after loading the view.

        view.backgroundColor = .cyan
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        self.view.backgroundColor = .blue

        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        mapView.styleURL = MGLStyle.lightStyleURL(withVersion: 9)
        mapView.tintColor = UIColor.blue
    }

    internal var mapView: MGLMapView = {
        let mapView = MGLMapView()
        return mapView
    }()

}
