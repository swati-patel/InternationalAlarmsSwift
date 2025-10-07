//
//  RegionDaoTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  RegionDaoTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 12/01/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class RegionDaoTests: XCTestCase {
    
    let INDIA_COUNTRY_ID = 113
    let NUM_REGIONS = 35
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetRegionList() {
        let list = RegionDao.getRegionList(for: INDIA_COUNTRY_ID)
        
        XCTAssertEqual(list.count, NUM_REGIONS, 
                      "Expected \(NUM_REGIONS) but got \(list.count)")
        
        for region in list {
            XCTAssertGreaterThanOrEqual(region.regionId, 0, "Invalid region id")
            XCTAssertFalse(region.name.isEmpty, "Invalid region name")
            XCTAssertGreaterThanOrEqual(region.countryId, 0, "Invalid country id")
        }
    }
}