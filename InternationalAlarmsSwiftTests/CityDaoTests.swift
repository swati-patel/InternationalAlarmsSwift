//
//  CityDaoTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  CityDaoTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 12/01/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class CityDaoTests: XCTestCase {
    
    let GUJARAT_REGION_ID = 2175
    let NUM_CITIES_GUJARAT = 39
    
    let INDIA_COUNTRY_ID = 113
    let NUM_CITIES_INDIA = 572
    
    let NAVSARI_CITY_ID = 42626
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetCityListByRegion() {
        let cities = CityDao.getCityListByRegion(regionId: GUJARAT_REGION_ID) ?? []
        XCTAssertEqual(cities.count, NUM_CITIES_GUJARAT,
                      "Expected \(NUM_CITIES_GUJARAT) cities for Gujarat but got: \(cities.count)")
        
        for city in cities {
            XCTAssertGreaterThanOrEqual(city.cityId, 0, "Invalid cityid")
            XCTAssertGreaterThanOrEqual(city.countryId, 0, "Invalid countryid")
            XCTAssertGreaterThanOrEqual(city.regionId, 0, "Invalid regionid")
            XCTAssertFalse(city.name.isEmpty, "Invalid name")
            XCTAssertNotNil(city.timezone, "Invalid timezone")
        }
    }
    
    func testGetCityListByCountry() {
        let cities = CityDao.getCityListByCountry(countryId: INDIA_COUNTRY_ID) ?? []
        XCTAssertEqual(cities.count, NUM_CITIES_INDIA,
                      "Expected \(NUM_CITIES_INDIA) cities for India but got: \(cities.count)")
        
        for city in cities {
            XCTAssertGreaterThanOrEqual(city.cityId, 0, "Invalid cityid")
            XCTAssertGreaterThanOrEqual(city.countryId, 0, "Invalid countryid")
            XCTAssertGreaterThanOrEqual(city.regionId, 0, "Invalid regionid")
            XCTAssertFalse(city.name.isEmpty, "Invalid name")
            XCTAssertNotNil(city.timezone, "Invalid timezone")
        }
    }
    
    func testGetCityName() {
        let city = CityDao.getCityName(id: NAVSARI_CITY_ID)
        
        let expected = "Navsari"
        XCTAssertEqual(city, expected, "Expected: \(expected) but got \(city ?? "nil")")
    }
}