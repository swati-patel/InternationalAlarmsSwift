//
//  CountryDaoTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  CountryDaoTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 12/01/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class CountryDaoTests: XCTestCase {
    
    let NUM_COUNTRIES = 275
    let INDIA_COUNTRY_ID = 113
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetCountryList() {
        let list = CountryDao.getCountryList()
        XCTAssertEqual(list.count, NUM_COUNTRIES,
                      "Expected \(NUM_COUNTRIES): but got: \(list.count)")
        
        for country in list {
            XCTAssertFalse(country.name.isEmpty, "Country name in getCountryList is empty")
            XCTAssertGreaterThanOrEqual(country.countryId, 0, "Country id in getCountryList is invalid")
            XCTAssertFalse(country.mapReference.isEmpty, "Country mapReference in getCountryList is empty")
        }
    }
    
    func testGetCountryName() {
        let country = CountryDao.getCountryName(id: INDIA_COUNTRY_ID)
        
        let expected = "India"
        XCTAssertEqual(country, expected, "Expected \(expected): but got: \(country ?? "nil")")
    }
    
    func testGetCountryMapReference() {
        let country = CountryDao.getCountryName(id: INDIA_COUNTRY_ID)
        
        let expected = "India"
        XCTAssertEqual(country, expected, "Expected \(expected): but got: \(country ?? "nil")")
    }
}