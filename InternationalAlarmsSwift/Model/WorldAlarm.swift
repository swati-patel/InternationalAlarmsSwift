//
//  Alarm.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//


import Foundation

class WorldAlarm {
    var alarmId: Int
    var countryId: Int
    var cityId: Int
    var date: Date
    var description: String?
    var sound: String?
    var repeatValue: String?
    var uuidValue: String?
    
    init(date: Date) {
        self.alarmId = 0
        self.countryId = 0
        self.cityId = 0
        self.date = date
        self.description = nil
        self.sound = nil
        self.repeatValue = nil
        self.uuidValue = nil
    }
    
    init(alarmId: Int, countryId: Int, cityId: Int, date: Date, desc: String?, sound: String?, repeat repeatVal: String?, uuid uuidVal: String?) {
        self.alarmId = alarmId
        self.countryId = countryId
        self.cityId = cityId
        self.date = date
        self.sound = sound
        self.repeatValue = repeatVal
        self.uuidValue = uuidVal
        
        if let descVal = desc, !descVal.isEmpty {
            let firstLetter = descVal.prefix(1).capitalized
            let remaining = descVal.dropFirst()
            self.description = firstLetter + remaining
        } else {
            self.description = nil
        }
    }
}
