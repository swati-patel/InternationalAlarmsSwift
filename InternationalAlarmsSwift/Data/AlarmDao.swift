//
//  AlarmDao.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation

class AlarmDao {
    
    static let shared = AlarmDao()
    private init() {}
    
    static private let selectAlarms = "SELECT * FROM Alarms"
    static private let saveAlarm = "INSERT INTO Alarms VALUES"
    static private let deleteAlarm = "DELETE FROM Alarms WHERE alarmid="
    static private let numCols = 7
    
    static let dbHelper = DatabaseHelper.shared
    
    // MARK: - Get all alarms
    static func getAlarmList() -> [Alarm] {
        let alarmDataList = dbHelper.executeSelectQueryWithNumCols(numCols: numCols, query: selectAlarms) ?? []
        
        var alarmList: [Alarm] = []
        
        for row in alarmDataList {
            guard row.count >= 7 else { continue }
            
            let alarmId = (row[0] as? NSNumber)?.intValue ?? 0
            let countryId = (row[1] as? NSNumber)?.intValue ?? 0
            let cityId = (row[2] as? NSNumber)?.intValue ?? 0
            let dateString = row[3] as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let date = dateFormatter.date(from: dateString) else { continue }
            
            let desc = row[4] as? String
            let sound = row[5] as? String
            let repeatValue = row[6] as? String
            
            let alarm = Alarm(alarmId: alarmId,
                            countryId: countryId,
                            cityId: cityId,
                            date: date,
                            desc: desc,
                            sound: sound,
                            repeat: repeatValue)
            
            alarmList.append(alarm)
        }
        
        return alarmList
    }
    
    // MARK: - Save alarm
    static func saveAlarm(countryId: Int, cityId: Int, alarm: String, desc: String?, sound: String?, repeatVal: String?) -> Int {
        let values = "(NULL, '\(countryId)', '\(cityId)', '\(alarm)', '\(desc ?? "")', '\(sound ?? "")', '\(repeatVal ?? "")');"
        let saveCmd = saveAlarm + values
        dbHelper.executeQuery(saveCmd)
        return dbHelper.getLastId()
    }
    
    // MARK: - Delete alarm
    static func deleteAlarm(withId alarmId: Int) {
        let deleteCmd = deleteAlarm + "\(alarmId)"
        dbHelper.executeQuery(deleteCmd)
        print("Alarm deleted from DB")
    }
}
