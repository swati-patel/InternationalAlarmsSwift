//
//  TimeZoneUtilsTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  TimeZoneUtilsTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 7/07/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class TimeZoneUtilsTests: XCTestCase {
    
    var countries: [Country] = []
    
    override func setUp() {
        super.setUp()
        countries = CountryDao.getCountryList()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func findCountry(name: String) -> Country? {
        for country in countries {
            if country.name == name {
                return country
            }
        }
        print("Whoops could not find country name of: \(name)")
        return nil
    }
    
    func findCity(cityList: [City], region: Int, name: String) -> City? {
        for city in cityList {
            if city.name == name && city.regionId == region {
                return city
            }
        }
        print("Whoops could not find city name of: \(name)")
        return nil
    }
    
    func testGetTimeZoneStringNZ() {
        guard let country = findCountry(name: "New Zealand"),
              let cities = CityDao.getCityListByCountry(countryId: country.countryId),
              let city1 = findCity(cityList: cities, region: 4706, name: "Auckland") else {
            XCTFail("Failed to find country or city")
            return
        }
        
        var timeZone = city1.timezone
        var expected = "Pacific/Auckland"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
        
        guard let city2 = findCity(cityList: cities, region: 4721, name: "Wellington") else {
            XCTFail("Failed to find Wellington")
            return
        }
        
        timeZone = city2.timezone
        expected = "Pacific/Auckland"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
    }
    
    func testGetTimeZoneStringAus() {
        guard let country = findCountry(name: "Australia"),
              let cities = CityDao.getCityListByCountry(countryId: country.countryId),
              let city1 = findCity(cityList: cities, region: 4, name: "Sydney") else {
            XCTFail("Failed to find country or city")
            return
        }
        
        var timeZone = city1.timezone
        var expected = "Australia/Sydney"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
        
        guard let city2 = findCity(cityList: cities, region: 3, name: "Gold Coast") else {
            XCTFail("Failed to find Gold Coast")
            return
        }
        
        timeZone = city2.timezone
        expected = "Australia/Brisbane"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
    }
    
    func testGetTimeZoneStringUS() {
        var nsTimeZone = TimeZone(identifier: "America/Creston")
        var dsOffset = nsTimeZone?.daylightSavingTimeOffset()
        
        nsTimeZone = TimeZone(identifier: "Pacific/Auckland")
        dsOffset = nsTimeZone?.daylightSavingTimeOffset()
        print("dsOffset: \(dsOffset ?? 0) \(nsTimeZone?.description ?? "") \(nsTimeZone?.identifier ?? "")")
        
        nsTimeZone = TimeZone(identifier: "America/Los_Angeles")
        dsOffset = nsTimeZone?.daylightSavingTimeOffset()
        print("dsOffset: \(dsOffset ?? 0) \(nsTimeZone?.description ?? "") \(nsTimeZone?.identifier ?? "")")
        
        guard let country = findCountry(name: "United States"),
              let cities = CityDao.getCityListByCountry(countryId: country.countryId),
              let city1 = findCity(cityList: cities, region: 126, name: "San Francisco") else {
            XCTFail("Failed to find country or city")
            return
        }
        
        var timeZone = city1.timezone
        var expected = "America/Los_Angeles"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
        
        guard let city2 = findCity(cityList: cities, region: 139, name: "Louisville") else {
            XCTFail("Failed to find Louisville")
            return
        }
        
        timeZone = city2.timezone
        expected = "America/Kentucky/Louisville"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
        
        guard let city3 = findCity(cityList: cities, region: 139, name: "Monticello") else {
            XCTFail("Failed to find Monticello")
            return
        }
        
        timeZone = city3.timezone
        expected = "America/Kentucky/Monticello"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
    }
    
    func testGetTimeZoneStringIndia() {
        guard let country = findCountry(name: "India"),
              let cities = CityDao.getCityListByCountry(countryId: country.countryId),
              let city = findCity(cityList: cities, region: 2182, name: "Mumbai") else {
            XCTFail("Failed to find country or city")
            return
        }
        
        let timeZone = city.timezone
        let expected = "Asia/Kolkata"
        XCTAssertEqual(timeZone, expected, "Expected: \(expected) but got \(timeZone ?? "nil")")
    }
    
    func testGetTimeZoneStringBlank() {
        guard let country = findCountry(name: "United States"),
              let cities = CityDao.getCityListByCountry(countryId: country.countryId),
              let city = findCity(cityList: cities, region: 155, name: "Scaly Mountain") else {
            XCTFail("Failed to find country or city")
            return
        }
        
        XCTAssertNil(city.timezone)
    }
}