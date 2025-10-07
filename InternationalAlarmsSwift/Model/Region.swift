//
//  Region.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation

class Region {
    var regionId: Int
    var countryId: Int
    var name: String

    init(name nameVal: String) {
        self.regionId = 0
        self.countryId = 0
        self.name = nameVal
    }

    init(regionId regionIdVal: Int, countryId countryIdVal: Int, name nameVal: String) {
        self.regionId = regionIdVal
        self.countryId = countryIdVal
        self.name = nameVal.capitalized
    }
}
