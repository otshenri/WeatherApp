//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Henri Ots on 10/01/2019.
//  Copyright © 2019 Henri Ots. All rights reserved.
//

import Foundation
import Alamofire

enum API{
    static let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/")
    static let appKey = "102c8a5bccfbf27c2f93fccb9d005147"
    
    static let weather = "weather?"
}

class NetworkManager {
    
    //Singleton pattern
    private static var sharedNetworkManager: NetworkManager = {
        
        let networkManager = NetworkManager(baseURL: API.baseURL!)
        return networkManager
    }()
    
    let baseURL: URL
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    func constructUrl(parameters:String) -> URL {
        if let url = URL(string: baseURL.absoluteString + parameters + "&appid=" + API.appKey) {
            return url
        }
        else{
            return URL(string: baseURL.absoluteString + "&appid=" + API.appKey)!
        }
        
    }
    
    //GET METHODS
    func getWeather(lat:String, lng:String, completion: @escaping (Weather?) -> Void) {
        let coordinateString = API.weather + "lat=" + lat + "&lon=" + lng
        let url = constructUrl(parameters: coordinateString)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                let weather = try? JSONDecoder().decode(Weather.self, from: response.data!)
                completion(weather)
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
}
