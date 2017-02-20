//
//  SocialServicesMapViewController.swift
//  HandyAccess
//
//  Created by Ana Ma on 2/19/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import Mapbox

class SocialServicesMapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var socialService1: SocialService1!
    var coordinates: Coordinates!
    
//    let locationManager: CLLocationManager = {
//        let locMan: CLLocationManager = CLLocationManager()
//        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locMan.distanceFilter = 50.0
//        return locMan
//    }()
//    var serviceLatitude = Float() {
//        didSet {
//            self.setUpMap()
//            self.mapView.reloadInputViews()
//        }
//    }
//    var serviceLongitude = Float() {
//        didSet {
//            self.setUpMap()
//            self.mapView.reloadInputViews()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(coordinates.long), longitude: Double(coordinates.lat)), zoomLevel: 14, animated: false)
        view.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        guard let validSocialServices1 = self.socialService1 else { return }
        let location = MGLPointAnnotation()
        location.coordinate = CLLocationCoordinate2D(latitude: Double(coordinates.long), longitude: Double(coordinates.lat))
        location.title = "Organization Name"
        location.subtitle = "\(validSocialServices1.organizationname)"
        
        // Add marker `location` to the map.
        mapView.addAnnotation(location)
        
        // Set the map’s center coordinate and zoom level.
        
        

//        
//        guard let validCoordinate = self.coordinates else { return }
//        self.mapView.setCenter(CLLocationCoordinate2D(latitude: validCoordinate.lat, longitude: validCoordinate.long), zoomLevel: 12, animated: false)
//        print("validCoordinate.lat\(validCoordinate.lat)")
//        print("validCoordinate.long\(validCoordinate.long)")
//        
//        self.edgesForExtendedLayout = []
//        self.view.addSubview(self.mapView)
//        
//        locationManager.delegate = self
//        mapView.delegate = self
        
        //setUpMap()
    }
    
//    func setUpMap() {
//        guard let validCoordinate = self.coordinates else { return }
//        //self.mapView.setCenter(CLLocationCoordinate2D(latitude: validCoordinate.lat, longitude: validCoordinate.long), zoomLevel: 12, animated: false)
//        print("validCoordinate.lat\(validCoordinate.lat)")
//        print("validCoordinate.long\(validCoordinate.long)")
//        
//        // Declare the marker `Organization Name` and set its coordinates, title, and subtitle.
//        guard let validSocialServices1 = self.socialService1 else { return }
//        let location = MGLPointAnnotation()
//        location.coordinate = CLLocationCoordinate2D(latitude: validCoordinate.lat, longitude: validCoordinate.long)
//        location.title = "Organization Name"
//        location.subtitle = "\(validSocialServices1.organizationname)"
//        
//        // Add marker `location` to the map.
//        self.mapView.addAnnotation(location)
//    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    private func setupViewHierarchy() {
//        self.edgesForExtendedLayout = []
//        self.view.addSubview(mapView)
//    }
    
    private func configureConstraints() {
        
    }
    
    private func adjustSubviews() {
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedAlways, .authorizedWhenInUse:
//            print("All good!")
//            manager.startUpdatingLocation()
//        case .denied, .restricted:
//            print("NOPE")
//        case .notDetermined:
//            print("IDK")
//            locationManager.requestAlwaysAuthorization()
//        }
//    }

//    lazy var mapView: MGLMapView = {
//        let mapView = MGLMapView()
//        return mapView
//    }()
    

}
