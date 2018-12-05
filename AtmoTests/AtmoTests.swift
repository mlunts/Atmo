//
//  AtmoTests.swift
//  AtmoTests
//
//  Created by Marina Lunts on 12/4/18.
//  Copyright © 2018 earine. All rights reserved.
//

import XCTest
@testable import Atmo

class CityName: XCTestCase {

    //var vc: ViewController!
    var weather = Weather()
    var city = City()
    
    override func setUp() {
        super.setUp()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        vc = storyboard.instantiateInitialViewController() as! ViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
         super.tearDown()
    }
    
    func testWindDirection() {
        let wind = weather.windDirection(degree: 0)
        XCTAssert(wind == "Южный")
    }

    func testCityToCoordinates() {
        city.setCoordinatesByCity(selectedCity: "Odessa")
        
    }

}
