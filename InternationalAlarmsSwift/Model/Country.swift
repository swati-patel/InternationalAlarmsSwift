//
//  Country.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//


import Foundation

class Country {
    var countryId: Int
    var name: String
    var mapReference: String
    var iso2: String

    init(countryId: Int, name: String, mapReference: String, iso2: String) {
        self.countryId = countryId
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        self.mapReference = mapReference
        self.iso2 = iso2
    }
}
