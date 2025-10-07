//
//  DatabaseHelperTests.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 7/10/2025.
//


//
//  DatabaseHelperTests.swift
//  InternationalAlarmsSwiftTests
//
//  Created by Swati Patel on 12/01/2014.
//

/* 
 
 !!!!!!!!  PLEASE NOTE THAT RUNNING THESE TESTS WILL DELETE ALL DATA IN THE ALARMS TABLE !!!!!!!!
 
 */

import XCTest
@testable import InternationalAlarmsSwift

class DatabaseHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        DatabaseHelper.shared.executeQuery("delete from alarms")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetInstance() {
        let dbHelper = DatabaseHelper.shared
        let dbHelper2 = DatabaseHelper.shared
        
        XCTAssertTrue(dbHelper === dbHelper2, "Got two different instances")
    }
    
    func testCheckAndCreateDatabase() {
        let dbHelper = DatabaseHelper.shared
        _ = dbHelper.checkAndCreateDatabase()
    }
    
    func testDeleteDatabase() {
        let dbHelper = DatabaseHelper.shared
        _ = dbHelper.checkAndCreateDatabase()
    }
    
    func testExecuteSelectQueryWithNumCols1() {
        let dbHelper = DatabaseHelper.shared
        _ = dbHelper.checkAndCreateDatabase()
        
        let query = "select countryid from Countries where country='New Zealand'"
        let list = dbHelper.executeSelectQueryWithNumCols(numCols: 1, query: query) ?? []
        XCTAssertEqual(list.count, 1, "Expected one row but got: \(list.count)")
        
        let vals = list[0]
        XCTAssertEqual(vals.count, 1, "Expected one column but got: \(vals.count)")
    }
    
    func testExecuteSelectQueryWithNumCols2() {
        let dbHelper = DatabaseHelper.shared
        _ = dbHelper.checkAndCreateDatabase()
        
        let query = "select country, countryid from Countries where country='New Zealand'"
        let list = dbHelper.executeSelectQueryWithNumCols(numCols: 2, query: query) ?? []
        XCTAssertEqual(list.count, 1, "Expected one row but got: \(list.count)")
        
        let vals = list[0]
        XCTAssertEqual(vals.count, 2, "Expected two columns but got: \(vals.count)")
    }
    
    func testExecuteInsertQuery() {
        let dbHelper = DatabaseHelper.shared
        _ = dbHelper.checkAndCreateDatabase()
        
        let selectQuery = "select alarm from alarms"
        var list = dbHelper.executeSelectQueryWithNumCols(numCols: 1, query: selectQuery) ?? []
        XCTAssertEqual(list.count, 0, "Expected no rows but got: \(list.count)")
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.string(from: now)
        
        let query = "INSERT INTO Alarms VALUES (null, '1', '5976', '\(date)', 'description', 'piano_long.mp3', 'none')"
        
        dbHelper.executeQuery(query)
        
        list = dbHelper.executeSelectQueryWithNumCols(numCols: 1, query: selectQuery) ?? []
        XCTAssertEqual(list.count, 1, "Expected one row but got: \(list.count)")
    }
}