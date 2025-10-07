//
//  City.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//


import Foundation

class City {
    var cityId: Int
    var countryId: Int
    var regionId: Int
    var name: String
    var timezone: String?

    init(name: String) {
        self.cityId = 0
        self.countryId = 0
        self.regionId = 0
        self.name = name
        self.timezone = nil
    }

    init(cityId: Int, countryId: Int, regionId: Int, name: String, timezone: String?) {
        self.cityId = cityId
        self.countryId = countryId
        self.regionId = regionId
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let trimmedTimezone = timezone?.trimmingCharacters(in: .whitespaces)
        if let tz = trimmedTimezone, !tz.isEmpty {
            self.timezone = tz
        } else {
            self.timezone = nil
        }
    }
}
