//
//  RegionTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  RegionTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 5/01/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class RegionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitWithName() {
        let region = Region(name: "Wellington")
        XCTAssertEqual(region.name, "Wellington", "Region name not assigned")
    }
    
    func testInitWithRegionId() {
        let region = Region(regionId: 1, countryId: 2, name: "Wellington")
        
        XCTAssertEqual(region.regionId, 1, "Region id not assigned")
        XCTAssertEqual(region.countryId, 2, "Country id not assigned")
        XCTAssertEqual(region.name, "Wellington", "Region name not assigned")
    }
}