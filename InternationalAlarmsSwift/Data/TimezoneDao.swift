//
//  TimezoneDao.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation

class TimezoneDao {

    private static var dbHelper: DatabaseHelper? = DatabaseHelper.shared
    private static let selectTimezone = "select Code, Timezone from Timezones"
    private static let selectTimezoneByCode = "select code, timezone from Timezones where code="
    
    private static var timezoneList: [Timezone]?

    // Get all timezones
    static func getTimezoneList() -> [Timezone] {
        if timezoneList == nil {
            guard let dbHelper = dbHelper else { return [] }
            
            let dataList = dbHelper.executeSelectQueryWithNumCols(numCols: 2, query: selectTimezone) ?? []
            
            timezoneList = []
            
            for row in dataList {
                guard row.count >= 2 else { continue }
                
                let tzCode = row[0] as? String ?? ""
                let tzString = row[1] as? String ?? ""
                
                let timezone = Timezone(tzCode: tzCode, tzString: tzString)
                timezoneList?.append(timezone)
            }
        }
        return timezoneList ?? []
    }
    
    // Get timezones for a specific country code
    static func getTimezoneList(byCountryCode tzCode: String) -> [Timezone] {
        guard let dbHelper = dbHelper else { return [] }
        
        let queryString = "\(selectTimezoneByCode)'\(tzCode)'"
        let dataList = dbHelper.executeSelectQueryWithNumCols(numCols: 2, query: queryString) ?? []
        
        var filteredList: [Timezone] = []
        
        for row in dataList {
            guard row.count >= 2 else { continue }
            
            let tzCode = row[0] as? String ?? ""
            let tzString = row[1] as? String ?? ""
            
            let timezone = Timezone(tzCode: tzCode, tzString: tzString)
            filteredList.append(timezone)
        }
        
        return filteredList
    }
}
