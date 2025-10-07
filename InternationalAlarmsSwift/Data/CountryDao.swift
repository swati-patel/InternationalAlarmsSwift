//
//  CountryDao.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation

class CountryDao {
    
    private static var dbHelper: DatabaseHelper? = DatabaseHelper.shared
    
    private static let selectCountries = "select countryid, country, mapReference, iso2 from Countries"
    private static let selectCountryById = "select countryid, country, mapReference, iso2 from Countries where countryid="
    
    private static var countryList: [Country]?
    private static var countryDataList: [[Any]]?
    
    static func getCountryList() -> [Country] {
        guard let dbHelper = dbHelper else { return [] }
        
        if countryList == nil {
            countryDataList = dbHelper.executeSelectQueryWithNumCols(numCols: 4, query: selectCountries)
            
            countryList = []
            
            if let dataList = countryDataList {
                for row in dataList {
                    guard row.count >= 4 else { continue }
            
                    let countryId = Int(row[0] as? String ?? "0") ?? 0
                    let name = row[1] as? String ?? ""
                    let mapReference = row[2] as? String ?? ""
                    let iso2 = row[3] as? String ?? ""
                    
                    let country = Country(countryId: countryId, name: name, mapReference: mapReference, iso2: iso2)
                    countryList?.append(country)
                }
            }
        }
        
        countryList?.remove(at: 0)
        
        return countryList ?? []
    }
    
    static func getCountryById(id: Int) -> Country? {
        guard let dbHelper = dbHelper else { return nil }
        
        let query = "\(selectCountryById)\(id)"
        let list = dbHelper.executeSelectQueryWithNumCols(numCols: 4, query: query)
        
        guard let list = list else { return nil }
        
        if list.count != 1 {
            print("ERROR!! expected 1 item, got: \(list.count)")
        }
        
        guard let row = list.first, row.count >= 4 else { return nil }
        
        let countryId = (row[0] as? NSNumber)?.intValue ?? 0
        let name = row[1] as? String ?? ""
        let mapReference = row[2] as? String ?? ""
        let iso2 = row[3] as? String ?? ""
        
        return Country(countryId: countryId, name: name, mapReference: mapReference, iso2: iso2)
    }
    
    static func getCountryNameById(id: Int) -> String? {
        guard let dbHelper = dbHelper else { return nil }
        
        let query = "\(selectCountryById)\(id)"
        let list = dbHelper.executeSelectQueryWithNumCols(numCols: 4, query: query)
        
        guard let list = list else { return nil }
        
        if list.count != 1 {
            print("ERROR!! expected 1 item, got: \(list.count)")
        }
        
        return list.first?[1] as? String
    }
    
    static func getCountryName(id: Int) -> String? {
        if let countries = countryList {
            return countries.first(where: { $0.countryId == id })?.name
        } else {
            return getCountryNameById(id: id)
        }
    }
}
