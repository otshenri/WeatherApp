//
//  WeatherTests.swift
//  WeatherAppTests
//
//  Created by Henri Ots on 10/01/2019.
//  Copyright © 2019 Henri Ots. All rights reserved.
//

import Foundation
import XCTest

@testable import WeatherApp

class WeatherTests: XCTestCase {
    
    func testCalvinToCelcius() {
        let temp300 = WeatherAttributes(temp: 300)
        let temp0 = WeatherAttributes(temp: 0)
        let tempMinus300 = WeatherAttributes(temp: -300)
        let temp273 = WeatherAttributes(temp: 273.15)
        
        XCTAssertTrue(temp300.tempRoundedCelcius() == "26.9C")
        XCTAssertTrue(temp0.tempRoundedCelcius() == "-273.1C")
        XCTAssertTrue(tempMinus300.tempRoundedCelcius() == "-573.1C")
        XCTAssertTrue(temp273.tempRoundedCelcius() == "0.0C")
    }
    
}
