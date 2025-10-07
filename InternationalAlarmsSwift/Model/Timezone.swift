//
//  Timezone.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//


import Foundation

class Timezone {
    var countryCode: String
    var timezoneString: String

    init(tzCode: String, tzString: String) {
        self.countryCode = tzCode
        self.timezoneString = tzString
    }
}
