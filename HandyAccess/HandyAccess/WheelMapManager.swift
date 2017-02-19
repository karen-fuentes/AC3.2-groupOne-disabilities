//
//  WheelMap.swift
//  HandyAccess
//
//  Created by Miti Shah on 2/18/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import Foundation

class WheelMapManager{
    static let manager: WheelMapManager = WheelMapManager()
    private init () {}
    
    internal func getData(endpoint:String, completion: @escaping([WheelMapLocations]?) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("DBHuA5kGsDLCviNccbgS", forHTTPHeaderField: "X-API-KEY")
        request.addValue("Basic a2V5LTE6REJIdUE1a0dzRExDdmlOY2NiZ1M=", forHTTPHeaderField: "Authorization")
        
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data:Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error)
            }
            guard let validData = data else { return }
            
            let location = WheelMapManager.manager.getData(from: validData)
            
            completion(location)
            
            }.resume()
    }
    
    func getData(from data: Data) -> [WheelMapLocations]? {
        do {
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: [])
            var allData = [WheelMapLocations]()
            
            guard let json = jsonData as? [String:Any],
                let nodes = json["nodes"] as? [[String:Any]] else {return nil}
            
            for node in nodes {
                guard let name = node["name"] as? [String:Any],
                    let wheelchair = node["wheelchair"] as? String,
                    let wheelchair_toilet = node["wheelchair_toilet"] as? String,
                    let node_type = node["node_type"] as? [String: String],
                    let nodeIdentifier = node_type["identifier"],
                    let lat = node["lat"] as? Double,
                    let lon = node["lon"] as? Double else {return nil}
                
                
            }
            return allData
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
