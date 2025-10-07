//
//  CityTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  CityTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 5/01/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class CityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitWithName() {
        let city = City(name: "Wellington")
        XCTAssertEqual(city.name, "Wellington", "City name not assigned")
    }
    
    func testInitWithCityId() {
        let city = City(cityId: 1, countryId: 2, regionId: 3, name: "Wellington", timezone: "GMT")
        XCTAssertEqual(city.cityId, 1, "City id not assigned")
        XCTAssertEqual(city.countryId, 2, "Country id not assigned")
        XCTAssertEqual(city.regionId, 3, "Region id not assigned")
        XCTAssertEqual(city.name, "Wellington", "City name not assigned")
        XCTAssertEqual(city.timezone, "GMT", "City timezone not assigned")
    }
}