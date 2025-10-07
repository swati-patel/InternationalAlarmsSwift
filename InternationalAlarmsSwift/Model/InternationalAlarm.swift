//
//  InternationalAlarm.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation

class InternationalAlarm {
    var country: Country?
    var city: City?
    var alarm: Alarm
    var description: String

    init(country: Country?, city: City?, alarm: Alarm, description: String) {
        self.country = country
        self.city = city
        self.alarm = alarm
        self.description = description
    }
}
