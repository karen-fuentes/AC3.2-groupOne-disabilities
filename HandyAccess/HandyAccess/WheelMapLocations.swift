//
//  File.swift
//  HandyAccess
//
//  Created by Miti Shah on 2/18/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import Foundation

class WheelMapLocations {
    var name: String
    var wheelchair: String
    var wheelchair_toilet: String?
    var lat: Double
    var lon: Double
    var nodeIdentifier: String
    
    init(name: String, wheelchair: String, wheelchair_toilet: String?, lat: Double, lon: Double, nodeIdentifier: String) {
        self.name = name
        self.wheelchair = wheelchair
        self.wheelchair_toilet = wheelchair_toilet
        self.lat = lat
        self.lon = lon
        self.nodeIdentifier = nodeIdentifier
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
