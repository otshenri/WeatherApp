//
//  Weather.swift
//  WeatherApp
//
//  Created by Henri Ots on 10/01/2019.
//  Copyright © 2019 Henri Ots. All rights reserved.
//

import Foundation

struct Weather: Codable
{
    var details: [WeatherDetails]
    var attributes: WeatherAttributes
    var name:String
    
    enum CodingKeys: String, CodingKey {
        case details = "weather"
        case attributes = "main"
        case name
    }
}

struct WeatherDetails: Codable
{
    var desc:String
    
    enum CodingKeys: String, CodingKey {
        case desc = "description"
    }
}

struct WeatherAttributes: Codable
{
    var temp:Double
    static var kelvinConstant = 273.15
    
    func tempRoundedCelcius() -> String {
        let tempInCelcius = temp - WeatherAttributes.kelvinConstant
        let roundedTemp = String(format:"%.1fC", tempInCelcius)
        return roundedTemp
    }
    
    
}

