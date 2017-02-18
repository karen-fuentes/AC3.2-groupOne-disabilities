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
}

class APIRequestManager {
    
    static let shared = APIRequestManager()
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
    
}
