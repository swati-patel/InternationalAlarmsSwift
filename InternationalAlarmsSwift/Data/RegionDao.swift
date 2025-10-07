//
//  RegionDao.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation

class RegionDao {
    
    private static var regionList: [Region] = []
    private static var lastCountryID: Int?
    
    private static let numCols = 3
    private static var dbHelper: DatabaseHelper = DatabaseHelper.shared
    
    // Fetch list of regions for a given country
    static func getRegionList(for countryId: Int) -> [Region] {
        if let lastID = lastCountryID, lastID == countryId {
            return regionList // cached list
        }
        
        let query = "SELECT regionid, countryid, region FROM Regions WHERE countryid=\(countryId)"
        guard let regionDataList = dbHelper.executeSelectQueryWithNumCols(numCols: numCols, query: query) else {
            return []
        }
        
        regionList = []
        
        for row in regionDataList {
            guard row.count >= 3 else { continue }
            
            let regionId = (row[0] as? NSNumber)?.intValue ?? 0
            let countryId = (row[1] as? NSNumber)?.intValue ?? 0
            let name = row[2] as? String ?? ""
            
            let region = Region(regionId: regionId, countryId: countryId, name: name)
            regionList.append(region)
        }
        
        lastCountryID = countryId
        return regionList
    }
    
    // Fetch name of a region by its ID
    static func getRegionName(regionId: Int) -> String? {
        let query = "SELECT region FROM Regions WHERE regionid=\(regionId)"
        guard let regionDataList = dbHelper.executeSelectQueryWithNumCols(numCols: 1, query: query),
              regionDataList.count >= 1,
              let row = regionDataList.first else {
            return nil
        }
        
        return row[0] as? String
    }
}
