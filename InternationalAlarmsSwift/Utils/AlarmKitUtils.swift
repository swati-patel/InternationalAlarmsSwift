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
    // AlarmKitUtils.swift - Schedule Alarm
    static func scheduleAlarm(
        date: Date,
        content: String,
        sound: String?
    ) async throws -> String {
        
        print("In scheduleAlarm: sound: " + (sound ?? "default"))
        
        // Create alert content
        let alertContent = AlarmPresentation.Alert(
            title: LocalizedStringResource(stringLiteral: content),
            stopButton: .stopButton
        )
        
        // Create attributes
        let attributes = AlarmAttributes(
            presentation: AlarmPresentation(alert: alertContent),
            metadata: EmptyMetadata(),
            tintColor: Color.blue
        )
               
        let schedule = AlarmKit.Alarm.Schedule.fixed(date)
        
        // Create configuration
        let alarmConfiguration = AlarmConfiguration(
            schedule: schedule,
            attributes: attributes,
            secondaryIntent: nil,
            sound: .default
        )
      
        // Generate UUID for this alarm
        let alarmUUID = UUID()
        
        print("Scheduling alarm with UUID: \(alarmUUID.uuidString) for date: \(date)")
        
        print("About to schedule: date=\(date), content=\(content), sound=\(sound ?? "nil")")
        print("Date is in future: \(date > Date())")
        
        // Schedule the alarm
        let alarm = try await alarmManager.schedule(
            id: alarmUUID,
            configuration: alarmConfiguration
        )
        
        print("Alarm scheduled successfully: \(alarm.id)")
        
//        let allAlarms1 = try alarmManager.alarms
//        print("AFTER total scheduled alarms: \(allAlarms1.count)")
//        print("AFTER All scheduled alarms: \(allAlarms1)")
        
       // print("Scheduled alarm state: \(alarm)")
        
        return alarmUUID.uuidString
    }
    
    // for test purposes only
    static func deleteAllAlarms() async {
        do {
            let allAlarms = try alarmManager.alarms
        
       // print("All scheduled alarms: \(allAlarms)")
        for a in allAlarms {
            try await AlarmKitUtils.cancelAlarm(uuid: a.id.uuidString)
            }
        }
        catch {
            
        }
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
