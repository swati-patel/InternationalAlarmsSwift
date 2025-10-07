//
//  Location.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//


import Foundation

class Location: Comparable {
    var country: Country
    var city: City
    var timezone: String
    var name: String

    init(country: Country, city: City, timezone: String, isDuplicate: Bool) {
        self.country = country
        self.city = city
        self.timezone = timezone
        
        if isDuplicate {
            if let region = RegionDao.getRegionName(regionId: city.regionId) {
                self.name = "\(city.name), \(region), \(country.name)"
            } else {
                self.name = "\(city.name), \(country.name)"
            }
        } else {
            self.name = "\(city.name), \(country.name)"
        }
    }

    // Comparable conformance
    static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.name < rhs.name
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name
    }
}
