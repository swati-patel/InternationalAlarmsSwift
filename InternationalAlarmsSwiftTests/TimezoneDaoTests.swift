//
//  TimezoneDaoTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  TimezoneDaoTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 10/07/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class TimezoneDaoTests: XCTestCase {
    
    let NUM_TIMEZONES = 416
    let NUM_US_TIMEZONES = 29
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetTimezoneList() {
        let list = TimezoneDao.getTimezoneList()
        XCTAssertEqual(list.count, NUM_TIMEZONES,
                      "Expected \(NUM_TIMEZONES): but got: \(list.count)")
        
        for timezone in list {
            XCTAssertFalse(timezone.countryCode.isEmpty, "Country code in getTimezoneList is empty")
            XCTAssertFalse(timezone.timezoneString.isEmpty, "Timezone in getTimezoneList is empty")
        }
    }
    
    func testGetTimezoneListByCode() {
        let list = TimezoneDao.getTimezoneList(byCountryCode: "US")
        XCTAssertEqual(list.count, NUM_US_TIMEZONES,
                      "Expected \(NUM_US_TIMEZONES): but got: \(list.count)")
        
        for timezone in list {
            XCTAssertEqual(timezone.countryCode, "US", 
                          "Country code in getTimezoneListbyCode='US' is not 'US'")
            XCTAssertFalse(timezone.timezoneString.isEmpty, "Timezone in getTimezoneList is empty")
        }
    }
}