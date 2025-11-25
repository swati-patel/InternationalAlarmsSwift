//
//  AlarmKitUtils.swift
//  InternationalAlarmsSwift
//
//  Created by Swati Patel on 23/11/2025.
//

import Foundation
import AlarmKit
import SwiftUI
import ActivityKit

struct EmptyMetadata: AlarmMetadata {
    // That's it - nothing else needed
}


class AlarmKitUtils {
    
    typealias AlarmConfiguration = AlarmManager.AlarmConfiguration<EmptyMetadata>
    
    private static let alarmManager = AlarmManager.shared
    
    // MARK: - Request Authorization
    static func requestAuthorization() async throws -> Bool {
        print("Requesting AlarmKit authorization...")
        let state = try await alarmManager.requestAuthorization()
        
        if state == .authorized {
            print("AlarmKit authorized")
            return true
        } else {
            print("AlarmKit not authorized: \(state)")
            return false
        }
    }
    
    // MARK: - Schedule Alarm
    static func scheduleAlarm(
        date: Date,
        country: String?,
        city: String?,
        description: String?
    ) async throws -> String {
        
        // Create alert content
        let title = description ?? "World Alarm"
        let alertContent = AlarmPresentation.Alert(
            title: LocalizedStringResource(stringLiteral: title),
            stopButton: .stopButton
        )
    
        
        // Create attributes
        let attributes = AlarmAttributes(
            presentation: AlarmPresentation(alert: alertContent),
            metadata: EmptyMetadata(),
            tintColor: Color.blue
        )
        
        // Create schedule from date
       // let calendar = Calendar.current
       // let components = calendar.dateComponents([.hour, .minute], from: date)
        
        let schedule = AlarmKit.Alarm.Schedule.fixed(date)
        
//        let time2 = AlarmKit.Alarm.Schedule.Relative.Time(
//            hour: components.hour ?? 0,
//            minute: components.minute ?? 0
//        )
//        let schedule2 = AlarmKit.Alarm.Schedule.relative(.init(
//            time: time,
//            repeats: .never
//        ))
        
        // Create configuration
       // let alarmConfiguration1 = AlarmConfiguration(
        
        // Create configuration
        let alarmConfiguration = AlarmConfiguration(
            schedule: schedule,
            attributes: attributes,
            sound: .named("piano_longgg.mp3")
        )
        
        // Generate UUID for this alarm
        let alarmUUID = UUID()
        
        print("Scheduling alarm with UUID: \(alarmUUID.uuidString) for date: \(date)")
        
        // Schedule the alarm
        let alarm = try await alarmManager.schedule(
            id: alarmUUID,
            configuration: alarmConfiguration
        )
        
        print("Alarm scheduled successfully: \(alarm.id)")
        
        let allAlarms = try alarmManager.alarms
        print("All scheduled alarms: \(allAlarms)")
        
        print("Scheduled alarm state: \(alarm)")
        
        return alarmUUID.uuidString
    }
    
    // MARK: - Cancel Alarm
    static func cancelAlarm(uuid: String) async throws {
        guard let alarmUUID = UUID(uuidString: uuid) else {
            print("Invalid UUID string: \(uuid)")
            throw NSError(domain: "AlarmKitUtils", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid UUID"])
        }
        
        print("Cancelling alarm with UUID: \(uuid)")
        try await alarmManager.cancel(id: alarmUUID)
        print("Alarm cancelled successfully")
    }
}

extension AlarmButton {
    static var stopButton: Self {
        AlarmButton(text: "Done", textColor: .white, systemImageName: "stop.circle")
    }
}
