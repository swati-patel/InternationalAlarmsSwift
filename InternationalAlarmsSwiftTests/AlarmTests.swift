//
//  AlarmTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  AlarmTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 5/01/2014.
//

import XCTest
@testable import InternationalAlarmsSwift

class AlarmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here; it will be run once, before the first test case.
    }
    
    override func tearDown() {
        // Put teardown code here; it will be run once, after the last test case.
        super.tearDown()
    }
    
    func testInitWithDate() {
        let now = Date()
        let alarm = WorldAlarm(date: now)
        let formatter = DateFormatter()
        
        print("date: \(formatter.string(from: now))")
        print("date2: \(formatter.string(from: alarm.date))")
        
        // TODO: I don't know why the string to assertTrue does not print the dates when they are not equal.
        XCTAssertEqual(alarm.date.compare(now), .orderedSame,
                      "Expected date: \(formatter.string(from: now)) but got: \(formatter.string(from: alarm.date))")
    }
}
