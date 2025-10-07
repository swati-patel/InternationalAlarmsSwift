//
//  DateUtils.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 6/10/2025.
//


//
//  DateUtils.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 5/10/2025.
//

import Foundation
import UserNotifications

class DateUtils {
    
    static func getFormattedDate(formatter: DateFormatter, style: DateFormatter.Style, date: Date) -> String {
        formatter.dateStyle = style
        let day = formatter.string(from: date)
        return day
    }
    
    static func getFormattedTime(formatter: DateFormatter, date: Date) -> String {
        formatter.dateFormat = "h:mma"
        let time = formatter.string(from: date)
        return time
    }
    
    static func getCurrentTimeInOtherZone(timezone: String) -> String {
        let now = Date()
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(identifier: timezone)
        var currentTime = getFormattedDate(formatter: formatter, style: .short, date: now)
        let currentDate = getFormattedTime(formatter: formatter, date: now)
        currentTime += " "
        currentTime += currentDate
        
        return currentTime
    }
    
    static func getLocalTimeInOtherZone(timezone: String, forDate date: Date) -> Date {
        let formatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        
        var components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
        
        components.timeZone = TimeZone(identifier: timezone)
        components.calendar = calendar
        
        formatter.timeZone = TimeZone.current
        
        let newDate = components.date ?? date
        
        return newDate
    }
    
    static func stringFromDate(newDate: Date) -> String {
        let formatter = DateFormatter()
        
        var localTime = getFormattedDate(formatter: formatter, style: .long, date: newDate)
        let localDate = getFormattedTime(formatter: formatter, date: newDate)
        localTime += " "
        localTime += localDate
        
        return localTime
    }
    
    static func stringFromDateShortStyle(newDate: Date) -> String {
        let formatter = DateFormatter()
        
        var localTime = getFormattedDate(formatter: formatter, style: .short, date: newDate)
        let localDate = getFormattedTime(formatter: formatter, date: newDate)
        localTime += " "
        localTime += localDate
        
        return localTime
    }
    
    static func daysBetweenDate2(fromDateTime: Date, andDate toDateTime: Date) -> String {
        let interval = toDateTime.timeIntervalSince(fromDateTime)
        
        let totalmin = Int(interval / 60)
        
        var days: Int = 0
        var hours = totalmin / 60
        
        days = hours / 24
        
        let hoursRemaining = hours % 24
        hours = hoursRemaining
        
        let remainingMin = totalmin % 60
        
        let daysStr: String
        let hoursStr: String
        let minStr: String
        
        if days == 0 {
            daysStr = ""
        } else {
            daysStr = "\(days)D"
        }
        
        if hours == 0 {
            hoursStr = ""
        } else {
            hoursStr = "\(hours)H"
        }
        
        minStr = "\(remainingMin)M"
        
        let timeBetween = "\(daysStr) \(hoursStr) \(minStr)"
        
        return timeBetween
    }
    
    static func daysBetweenDate(fromDateTime: Date, andDate toDateTime: Date) -> String {
        var fromDate: Date?
        var toDate: Date?
        
        let calendar = Calendar.current
        
        _ = calendar.dateInterval(of: .day, for: fromDateTime)
        _ = calendar.dateInterval(of: .day, for: toDateTime)
        
        let difference = calendar.dateComponents([.second], from: fromDateTime, to: toDateTime)
        
        return timeFormatted(totalSeconds: difference.second ?? 0)
    }
    
    static func timeFormatted(totalSeconds: Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    static func getFormattedDate(formatter: DateFormatter, date: Date) -> String {
        formatter.dateFormat = "h:mma"
        var time = formatter.string(from: date)
        time += " "
        formatter.dateStyle = .long
        let day = formatter.string(from: date)
        
        return "\(day): \(time)"
    }
    
    static func getDateForNotification(intDate: Date) -> String {
        let dateFormat2 = "HH:mm dd MM yyyy"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormat2
        
        let formattedDate = getFormattedDate(formatter: dateFormatter2, date: intDate)
        return formattedDate
    }
    
    static func setNotification(intDate: Date, withCountry country: String?, withCity city: String?, withTimeString timeString: String, withDesc description: String?, withSound sound: UNNotificationSound, withAlarmId alarmId: Int) {
        let content = UNMutableNotificationContent()
        
        if country == nil {
            content.body = "UTC alert at \n\(timeString)"
        } else if let city = city, let country = country {
            content.body = "Alert for \(city), \(country) at \n\(timeString)"
        } else if let country = country {
            content.body = "Alert for \(country) at \n\(timeString)"
        }
        
        var desc = description
        if desc == nil || desc?.isEmpty == true {
            desc = "My Event"
        }
        
        content.title = desc?.uppercased() ?? "MY EVENT"
        content.sound = sound
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: intDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "\(alarmId)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("NOTIFICATION SCHEDULED SUCCESSFULLY")
            }
        }
    }
    
    static func cancelNotification(alarmId: Int) {
        let center = UNUserNotificationCenter.current()
        let key = "\(alarmId)"
        
        center.getPendingNotificationRequests { requests in
            for request in requests {
                if request.identifier == key {
                    center.removePendingNotificationRequests(withIdentifiers: [key])
                    print("FOUND ALARM TO REMOVE: \(alarmId)")
                    return
                }
            }
            print("DIDN'T FIND NOTIFICATION")
        }
    }
    
    static func retrieveNotificationWithId(alarmId: Int) -> UNNotificationRequest? {
        var foundRequest: UNNotificationRequest?
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                if request.identifier == "\(alarmId)" {
                    foundRequest = request
                    break
                }
            }
        }
        
        return foundRequest
    }
    
    // For debug purposes
    static func displayCurrentNotifications() {
        print("DISPLAYING CURRENT NOTIFICATIONS")
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let totalNotifications = requests.count
            print("Total number of current notifications: \(totalNotifications)")
        }
        
        center.getPendingNotificationRequests { requests in
            for request in requests {
                let content = request.content
                print("Notification Identifier: \(request.identifier)")
                print("Notification Body: \(content.body)")
            }
        }
    }
    
    static func getLocalDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        return dateFormatter
    }
    
    static func getLocalDateFormatterForTimezone(timezone: String) -> DateFormatter {
        let dateFormatter = getLocalDateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter
    }
    
    static func getDateFormatter() -> DateFormatter {
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
    
    static func getDateFormatterForTimezone(timezone: String) -> DateFormatter {
        let intDf = getDateFormatter()
        intDf.timeZone = TimeZone(identifier: timezone)
        return intDf
    }
    
    static func getHourInTimeZone(timezone: String) -> Int {
        let now = Date()
        guard let tz = TimeZone(identifier: timezone) else { return 0 }
        
        var calendar = Calendar.current
        calendar.timeZone = tz
        
        let components = calendar.component(.hour, from: now)
        return components
    }
    
    static func getMinutesInTimeZone(timezone: String) -> Int {
        let now = Date()
        guard let tz = TimeZone(identifier: timezone) else { return 0 }
        
        var calendar = Calendar.current
        calendar.timeZone = tz
        
        let components = calendar.component(.minute, from: now)
        return components
    }
    
    static func getHourFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.component(.hour, from: date)
        return components
    }
    
    static func getMinutesFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.component(.minute, from: date)
        return components
    }
    
    static func isDayWithHour(hour: Int, minute: Int) -> Bool {
        if hour > 6 && hour < 18 {
            return true
        } else if hour == 6 && minute >= 0 {
            return true
        } else {
            return false
        }
    }
    
    static func isDayInTimeZone(timeZone: String) -> Bool {
        let hour = getHourInTimeZone(timezone: timeZone)
        let minute = getMinutesInTimeZone(timezone: timeZone)
        return isDayWithHour(hour: hour, minute: minute)
    }
    
    static func isDayForTime(date: Date) -> Bool {
        let hour = getHourFromDate(date: date)
        let minute = getMinutesFromDate(date: date)
        return isDayWithHour(hour: hour, minute: minute)
    }
}