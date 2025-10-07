//
//  CountryTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  CountryTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 5/01/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class CountryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//    func testInitWithName() {
//        let country = Country(name: "New Zealand")
//        XCTAssertEqual(country.name, "New Zealand", "Country name not assigned")
//    }
    
    func testInitWithCountryId() {
        let country = Country(countryId: 1, name: "New Zealand", mapReference: "Oceania", iso2: "NZ")
        
        XCTAssertEqual(country.countryId, 1, "Country id not assigned")
        XCTAssertEqual(country.name, "New Zealand", "Country name not assigned")
        XCTAssertEqual(country.mapReference, "Oceania", "Map Reference not assigned")
        XCTAssertEqual(country.iso2, "NZ", "iso2 not assigned")
    }
}