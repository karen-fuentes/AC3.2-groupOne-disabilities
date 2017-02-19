//
//  APIRequestManager.swift
//  HandyAccess
//
//  Created by Ana Ma on 2/18/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import Foundation

enum SocialServiceParseError: Error {
    case json
    case meta
    case view
    case columns
    case data
    case resource0
    case socialServices1
}

enum CoordinatesParseError: Error {
    case json
    case results
    case response
    case coordinates
}

class APIRequestManager {
    
    static let shared = APIRequestManager()
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
    func getSocialServices1(endPoint: String, callback: @escaping([SocialService1]?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            
            dump(validData)
            
            var socialServices1 = [SocialService1]()
            do {
                guard let jsonArray = try JSONSerialization.jsonObject(with: validData, options: []) as? [[String: Any]] else {
                    throw SocialServiceParseError.json
                }
                
                for resource in jsonArray{
                    guard let s = SocialService1(withDict: resource) else {
                        continue
                    }
                    socialServices1.append(s)
                }
                dump(socialServices1)
            }                
            catch SocialServiceParseError.json {
                print("SocialServiceParseError.json")
            }
            catch SocialServiceParseError.socialServices1 {
                print("SocialServiceParseError.socialServices1")
            }
            catch {
                print(error)
            }
            
            callback(socialServices1)
            }.resume()
    }
    
    func getSocialServicesViews(endPoint: String, callback: @escaping ([MetaView]?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            
            var metaViews = [MetaView]()
            do {
                guard let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any] else {
                    throw SocialServiceParseError.json
                }
                guard let meta = json["meta"] as? [String: Any] else {
                    throw SocialServiceParseError.meta
                }
                guard let view = meta["view"] as? [String: Any] else {
                    throw SocialServiceParseError.view
                }
                guard let columns = view["columns"] as? [[String: Any]] else {
                    throw SocialServiceParseError.columns
                }
                
                for column in columns {
                    let v = MetaView(dict: column)
                    metaViews.append(v)
                }
            }
            catch SocialServiceParseError.meta {
                print("SocialServiceParseError.meta")
            }
            catch SocialServiceParseError.json {
                print("SocialServiceParseError.json")
            }
            catch SocialServiceParseError.view {
                print("SocialServiceParseError.view")
            }
            catch SocialServiceParseError.columns {
                print("SocialServiceParseError.columns")
            }
            catch {
                print(error)
            }
            
            callback(metaViews)
            }.resume()
    }
    
    func getSocialServicesData(endPoint: String, metaViews: [MetaView], callback: @escaping ([SocialService]?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            
            var socialServices = [SocialService]()
            do {
                guard let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any] else {
                    throw SocialServiceParseError.json
                }
                guard let resoucesData = json["data"] as? [[Any]] else {
                    throw SocialServiceParseError.data
                }
                for resource in resoucesData{
                   let s = SocialService(array: resource)
                   socialServices.append(s)
                }
            }
            catch SocialServiceParseError.data {
                print("SocialServiceParseError.data")
            }
            catch SocialServiceParseError.json {
                print("SocialServiceParseError.json")
            }
            catch {
                print(error)
            }
            
            callback(socialServices)
            }.resume()
    }
    
    internal func getDataForCoordinates(address:String, borough: String, callback: @escaping([Coordinates]?) -> Void) {
        //https://api.cityofnewyork.us/geoclient/v1/search.json?app_id=1a4ac0f9&app_key=f6ecb3c64c54ece79b4667cae7ed96ad&input=%2031-00%2047th%20Ave%20queens
        //guard let urlBase = URL(string: "https://api.cityofnewyork.us/geoclient/v1/search.json?") else { return }
//        guard let urlBaseString = ("https://api.cityofnewyork.us/geoclient/v1/search.json?" + "input=" + address + " " + borough).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
//        guard let validBaseURL = URL(string: urlBaseString) else { return }
//        var request = URLRequest(url: validBaseURL)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("1a4ac0f9", forHTTPHeaderField: "app_id")
//        request.addValue("f6ecb3c64c54ece79b4667cae7ed96ad", forHTTPHeaderField: "app_key")
//        //request.addValue(urlExtension, forHTTPHeaderField: "input")
//        
//        print(request)
        
        guard let validURL = URL(string: "https://api.cityofnewyork.us/geoclient/v1/search.json?app_id=1a4ac0f9&app_key=f6ecb3c64c54ece79b4667cae7ed96ad&input=%2031-00%2047th%20Ave%20queens") else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: validURL) { (data:Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error)
            }
            guard let validData = data else { return }
            
            var coordinatesArray = [Coordinates]()
            
            do {
                guard let validJson = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any] else {
                    throw CoordinatesParseError.json
                }
//                let json = try JSONSerialization.jsonObject(with: validData, options: []) as? Any
//                guard let validJson = json as? [String: Any] else {
//                    throw CoordinatesParseError.json
//                }
                
                guard let resultsDict = validJson["results"] as? [[String: Any]] else {
                    throw CoordinatesParseError.results
                }
                
                for result in resultsDict{
                    guard let response = result["response"] as? [String: Any] else {
                        throw CoordinatesParseError.response
                    }
                    guard let c = Coordinates(with: response) else { continue }
                    coordinatesArray.append(c)
                }
            }
            catch CoordinatesParseError.json {
                print("CoordinatesParseError.json")
            }
            catch CoordinatesParseError.results {
                print("CoordinatesParseError.results")
            }
            catch {
                print(error)
            }
            
            dump(coordinatesArray)
            
            callback(coordinatesArray)
            
            }.resume()
    }

}
