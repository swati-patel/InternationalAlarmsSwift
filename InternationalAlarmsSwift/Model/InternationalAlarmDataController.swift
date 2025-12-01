//
//  InternationalAlarmDataController.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation
import UserNotifications

class InternationalAlarmDataController {
    
    var masterInternationalAlarmList: [InternationalAlarm] = []
    
    init() {
        initialiseDefaultDataList()
    }
    
    func initialiseDefaultDataList() {
        masterInternationalAlarmList = []
        
        let alarmList = AlarmDao.getAlarmList()
        
        for alarm in alarmList {
            var country: Country?
            
            if alarm.countryId != 0 {
                print("DEBUG: Fetching country with id: \(alarm.countryId)")
                country = CountryDao.getCountryById(id: alarm.countryId)
            }
            
            var city: City?
            var name: String?
            
            if alarm.cityId != 0 {
                print("DEBUG: Fetching city with cityId: \(alarm.cityId), countryId: \(alarm.countryId)")
                name = CityDao.getCityNameByCityId(cityIdVal: alarm.cityId, countryId: alarm.countryId)
            }
            
            if name != nil {
                city = CityDao.getCityById(cityId: alarm.cityId)
            } else {
                if let regionName = RegionDao.getRegionName(regionId: alarm.cityId) {
                    city = City(name: regionName)
                }
            }
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            
            let date = alarm.date
            let calendar = Calendar(identifier: .gregorian)
            let components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
            
            let alarm2 = WorldAlarm(
                alarmId: alarm.alarmId,
                countryId: alarm.countryId,
                cityId: alarm.cityId,
                date: alarm.date,
                desc: alarm.description,
                sound: alarm.sound,
                repeat: alarm.repeatValue,
                uuid: alarm.uuidValue
            )
            
            let description = alarm.description ?? ""
            
            
            print("DEBUG: calling addInternationalAlarm with - country: \(country?.name ?? "nil"), countryId: \(country?.countryId ?? 0)")
            
            addInternationalAlarm(country: country, city: city, alarm: alarm2, description: description)
        }
        
        masterInternationalAlarmList.sort { alarm1, alarm2 in
            guard let city1 = alarm1.city, let city2 = alarm2.city,
                  let timezone1 = city1.timezone, let timezone2 = city2.timezone else {
                return false
            }
            
            let df1 = DateFormatter()
            df1.timeZone = TimeZone(identifier: timezone1)
            df1.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let s1 = df1.string(from: alarm1.alarm.date)
            guard let d1 = df1.date(from: s1) else { return false }
            
            let df2 = DateFormatter()
            df2.timeZone = TimeZone(identifier: timezone2)
            df2.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let s2 = df2.string(from: alarm2.alarm.date)
            guard let d2 = df2.date(from: s2) else { return false }
            
            return d1.compare(d2) == .orderedAscending
        }
    }
    
    func countOfList() -> Int {
        return masterInternationalAlarmList.count
    }
    
    func objectInList(at index: Int) -> InternationalAlarm {
        return masterInternationalAlarmList[index]
    }
    
    func addInternationalAlarm(country: Country?, city: City?, alarm: WorldAlarm, description: String) {
        
        print("DEBUG: addInternationalAlarm - country: \(country?.name ?? "nil"), countryId: \(country?.countryId ?? 0)")
        print("DEBUG: addInternationalAlarm - city: \(city?.name ?? "nil"), cityId: \(city?.cityId ?? 0)")
        
        let intAlarm = InternationalAlarm(country: country, city: city, alarm: alarm, description: description)
        masterInternationalAlarmList.append(intAlarm)
    }
    
    func removeObjectFromMasterInternationalAlarmList(at index: Int) async {
        let alarm = masterInternationalAlarmList[index]
        let alarmId = alarm.alarm.alarmId
        
        masterInternationalAlarmList.remove(at: index)
        
        //DateUtils.cancelNotification(alarmId: alarmId)
        do {
            try await AlarmKitUtils.cancelAlarm(uuid: alarm.alarm.uuidValue!)
        } catch {
            print("Failed to cancel alarm: \(error)")
        }
        AlarmDao.deleteAlarm(withId: alarmId)
    }
    
    static func getFormattedDate(formatter: DateFormatter, date: Date) -> String {
        formatter.dateFormat = "h:mma"
        var time = formatter.string(from: date)
        time += " "
        formatter.dateStyle = .long
        let day = formatter.string(from: date)
        
        return time + day
    }
}
