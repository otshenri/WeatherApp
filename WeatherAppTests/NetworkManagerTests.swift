//
//  NetworkManagerTests.swift
//  WeatherAppTests
//
//  Created by Henri Ots on 10/01/2019.
//  Copyright © 2019 Henri Ots. All rights reserved.
//

import Foundation
import XCTest

@testable import WeatherApp

class NetworkManagerTests: XCTestCase {
    
    let londonCoordinates = ["51.5057", "-0.1"]
    let newYorkCoordinates = ["40.7128", "-74"]
    let SydneyCoordinates = ["-33.8688", "151.2093"]
    
    func testGetWeatherLondon() {
        let e = expectation(description: "Weather received, location correct")
        
        NetworkManager.shared().getWeather(lat: londonCoordinates[0], lng:londonCoordinates[1]) { weather in
            
            XCTAssertNotNil(weather, "Expected non-nil response")
            XCTAssertNotNil(weather?.attributes, "Expected non-nil response")
            XCTAssertNotNil(weather?.attributes.temp, "Expected non-nil response")
            XCTAssertNotNil(weather?.details, "Expected non-nil response")
            XCTAssertNotNil(weather?.details[0].desc, "Expected non-nil response")
            XCTAssertTrue(weather?.name == "City of London", "Expected City of London")
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetWeatherNewYork() {
        let e = expectation(description: "Weather received, location correct")
        
        NetworkManager.shared().getWeather(lat: newYorkCoordinates[0], lng:newYorkCoordinates[1]) { weather in
            
            XCTAssertNotNil(weather, "Expected non-nil response")
            XCTAssertNotNil(weather?.attributes, "Expected non-nil response")
            XCTAssertNotNil(weather?.attributes.temp, "Expected non-nil response")
            XCTAssertNotNil(weather?.details, "Expected non-nil response")
            XCTAssertNotNil(weather?.details[0].desc, "Expected non-nil response")
            XCTAssertTrue(weather?.name == "New York", "Expected New York")
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetWeatherSydney() {
        let e = expectation(description: "Weather received, location correct")
        
        NetworkManager.shared().getWeather(lat: SydneyCoordinates[0], lng:SydneyCoordinates[1]) { weather in
            
            XCTAssertNotNil(weather, "Expected non-nil response")
            XCTAssertNotNil(weather?.attributes, "Expected non-nil response")
            XCTAssertNotNil(weather?.attributes.temp, "Expected non-nil response")
            XCTAssertNotNil(weather?.details, "Expected non-nil response")
            XCTAssertNotNil(weather?.details[0].desc, "Expected non-nil response")
            XCTAssertTrue(weather?.name == "City of Sydney", "Expected City of Sydney")
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
