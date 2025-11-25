//
//  DatabaseUpdateUtils.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//


//
//  DatabaseUpdateUtils.swift
//  InternationalAlarmClock
//
//  Created by Swati Patel on 9/5/2024.
//  Converted to Swift 2025
//

import Foundation
import UserNotifications

class DatabaseUpdateUtils {
    
    private static let dbHelper = DatabaseHelper.shared
    
    static func updateAddUUIDFieldToAlarms() {
        let key = "DatabaseUpdateForUUIDField_23Nov2025"
        if UserDefaults.standard.bool(forKey: key) {
            print("Database update for UUID field already performed.")
            return
        }
        
        print("Updating database for \(key)")
        
        _ = dbHelper.openDatabase()
        
        let alterTableQuery = "ALTER TABLE Alarms ADD COLUMN AlarmUUID TEXT"
        print("Executing query: \(alterTableQuery)")
        dbHelper.executeQuery(alterTableQuery)
        print("AlarmUUID column added.")
        
        // Generate UUIDs for existing alarms
        let existingAlarms = AlarmDao.getAlarmList()
        
        // TODO - cancel notification, then add alarm to alarm kit
        
//        for alarm in existingAlarms {
//            let uuid = UUID().uuidString
//            let updateQuery = "UPDATE Alarms SET AlarmUUID = '\(uuid)' WHERE AlarmID = \(alarm.alarmId)"
//            print("Executing query: \(updateQuery)")
//            dbHelper.executeQuery(updateQuery)
//        }
        
        
       
        
        
//        for alarm in existingAlarms {
//            // Cancel old notification
//            DateUtils.cancelNotification(alarmId: alarm.alarmId)
//            
//            // Schedule with AlarmKit (this will generate/use proper UUID)
//            // ... AlarmKit scheduling code here ...
//            // Get back the UUID from AlarmKit
//            
//            // Update DB with that UUID
//            let updateQuery = "UPDATE Alarms SET AlarmUUID = '\(alarmKitUUID)' WHERE AlarmID = \(alarm.alarmId)"
//            dbHelper.executeQuery(updateQuery)
//        }
        
        print("UUIDs generated for existing alarms.")
        
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
        print("UUID field update completed.")
    }
    
    static func updateAddRepeatFieldToAlarms() {
        let key = "DatabaseUpdateForRepeatField_6May2025_V5"
        if UserDefaults.standard.bool(forKey: key) {
            print("Database update for RepeatType field already performed.")
            return
        }
        
        print("Updating database for \(key)")
        
        _ = dbHelper.openDatabase()
        
        let alterTableQuery = "ALTER TABLE Alarms ADD COLUMN RepeatType TEXT"
        print("Executing query: \(alterTableQuery)")
        dbHelper.executeQuery(alterTableQuery)
        print("RepeatType column added.")
        
        let defaultValue = "none"
        let updateQuery = "UPDATE Alarms SET RepeatType = '\(defaultValue)' WHERE RepeatType IS NULL"
        print("Executing query: \(updateQuery)")
        dbHelper.executeQuery(updateQuery)
        print("Default RepeatType value set.")
        
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
        print("RepeatType field update completed.")
    }
    
    static func updateAddSoundFieldToAlarms() {
        let key = "DatabaseUpdateForSoundField_1May2025"
        if UserDefaults.standard.bool(forKey: key) {
            print("Database update for sound field already performed.")
            return
        }
        
        print("Updating database for \(key)")
        
        _ = dbHelper.openDatabase()
        
        let alterTableQuery = "ALTER TABLE Alarms ADD COLUMN Sound TEXT"
        print("Executing query: \(alterTableQuery)")
        dbHelper.executeQuery(alterTableQuery)
        print("Column added.")
        
        let defaultSound = "piano_long.mp3"
        let updateSoundQuery = "UPDATE Alarms SET Sound = '\(defaultSound)' WHERE Sound IS NULL"
        print("Executing query: \(updateSoundQuery)")
        dbHelper.executeQuery(updateSoundQuery)
        print("Default sound set.")
        
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
        print("Sound field update completed.")
    }
    
    static func updateLocationNames() {
        let key = "DatabaseUpdateForLocationNames_1Apr2025"
        if UserDefaults.standard.bool(forKey: key) {
            print("Database update for update names already performed.")
            return
        }
        
        print("Updating database for \(key)")
        
        _ = dbHelper.openDatabase()
        
        let queries = [
            "UPDATE Countries SET Country = 'Democratic Republic of the Congo (DRC)' WHERE Country = 'Congo, Democratic Republic of the'",
            "UPDATE Countries SET Country = 'Republic of the Congo' WHERE Country = 'Congo, Republic of the'",
            "UPDATE Countries SET Country = 'North Korea' WHERE Country = 'Korea, North'",
            "UPDATE Countries SET Country = 'South Korea' WHERE Country = 'Korea, South'",
            "UPDATE Countries SET Country = 'North Macedonia' WHERE Country = 'Macedonia, The Former Yugoslav Republic of'",
            "UPDATE Countries SET Country = 'Isle of Man' WHERE Country = 'Man, Isle of'",
            "UPDATE Countries SET Country = 'Federated States of Micronesia' WHERE Country = 'Micronesia, Federated States of'",
            "UPDATE Countries SET Country = 'Palestine' WHERE Country = 'Palestinian Territory, Occupied'",
            "UPDATE Cities SET City = 'Washington DC' WHERE CityID = '40303'",
            "DELETE FROM Countries WHERE Country = 'France, Metropolitan'",
            "DELETE FROM Cities WHERE City = 'Washington Depot'"
        ]
        
        for query in queries {
            print("Executing query: \(query)")
            dbHelper.executeQuery(query)
            print("Query successful.....")
        }
        
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
        print("All done.....")
    }
    
    static func updateDatabaseAndPreserveAlarms() {
        let key = "DatabaseUpdateForTimezone_18May2024"
        if UserDefaults.standard.bool(forKey: key) {
            print("Database update already performed.")
            return
        }
        
        print("Updating database and preserving alarms...")
        
        let alarmList = AlarmDao.getAlarmList()
        
        if alarmList.count > 0 {
            print("There is data in the alarmsData array.")
        } else {
            print("There is no data in the alarmsData array.")
        }
        
        dbHelper.closeDatabase()
        dbHelper.deleteDatabase()
        _ = dbHelper.checkAndCreateDatabase()
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
        
        _ = dbHelper.openDatabase()
        
        for alarm in alarmList {
            let currentNotification = DateUtils.retrieveNotificationWithId(alarmId: alarm.alarmId)
            //let currentSound = currentNotification.content.sound
            let currentSound = currentNotification?.content.sound ?? UNNotificationSound(named: UNNotificationSoundName("piano_long.mp3"))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let alarmStr = dateFormatter.string(from: alarm.date)
            
            let description = (alarm.description == nil || alarm.description == "(null)") ? "My event" : alarm.description
            
            let defaultSound = "piano_long.mp3"
            let defaultRepeatValue = "none"
            
            // TODO UUID VAL
            let alarmId = AlarmDao.saveAlarm(
                countryId: alarm.countryId,
                cityId: alarm.cityId,
                alarm: alarmStr,
                desc: description,
                sound: defaultSound,
                repeatVal: defaultRepeatValue,
                uuidVal: " "
            )
            
            if alarmId != alarm.alarmId {
                print("New alarm ID is different")
                DateUtils.cancelNotification(alarmId: alarm.alarmId)
            } else {
                print("Alarm IDs are same")
            }
            
            var timezone = "GMT"
            var country: Country?
            var city: City?
            
            if alarm.countryId != 0 {
                country = CountryDao.getCountryById(id: alarm.countryId)
                city = CityDao.getCityById(cityId: alarm.cityId)
                timezone = city?.timezone ?? "GMT"
            }
            
            let intDf = DateUtils.getDateFormatterForTimezone(timezone: timezone)
            guard let intDate = intDf.date(from: alarmStr) else { continue }
            
            DateUtils.setNotification(
                intDate: intDate,
                withCountry: country?.name,
                withCity: city?.name,
                withTimeString: alarmStr,
                withDesc: description,
                withSound: currentSound,
                withAlarmId: alarmId
            )
        }
    }
}
