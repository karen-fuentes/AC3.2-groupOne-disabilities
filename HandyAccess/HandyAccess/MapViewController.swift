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
    var userLatitude: Float = 40.776104
    var userLongitude: Float = -73.920822

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        setupView()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: CLLocationDegrees(userLatitude), longitude: CLLocationDegrees(userLongitude))
        centerMapOnLocation(initialLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            manager.stopUpdatingLocation()
        case .denied, .restricted:
            print("Authorization denied or restricted")
        case .notDetermined:
            print("Authorization undetermined")
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.setCenter(coordinateRegion, zoomLevel: 13, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let validLocation: CLLocation = locations.last else { return }
        let locationValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        userLatitude =  Float(locationValue.latitude)
        userLongitude = Float(locationValue.longitude)
        

        
        let hello = MGLPointAnnotation()
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to my marker"
        
        geocoder.reverseGeocodeLocation(validLocation) { (placemarks: [CLPlacemark]?, error: Error?) in
            //error handling
            if error != nil {
                dump(error!)
            }
            
            guard let validPlaceMarks: [CLPlacemark] = placemarks,
                let validPlace: CLPlacemark = validPlaceMarks.last else { return }
            print(validPlace)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error encountered")
        dump(error)
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let newlogitude = center.longitude
        let newlatitude = center.latitude
        print("log = \(newlogitude), lat = \(newlatitude)")
        userLongitude = Float(newlogitude)
        userLatitude = Float(newlatitude)
    }
    
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }

    
    func setupView() {
//        mapView.setCenter(CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), zoomLevel: 9, animated: false)
    }

    internal var mapView: MGLMapView = {
        let mapView = MGLMapView()
        return mapView
    }()
    
//    internal var

}
