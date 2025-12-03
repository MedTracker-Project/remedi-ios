//
//  NotificationManager.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI
import UserNotifications
internal import Combine

final class NotificationManager: ObservableObject {
    
    init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func scheduleNotification(for medication: Medication) {
        let content = UNMutableNotificationContent()
        content.title = "Time to take \(medication.name)"
        content.body = "\(medication.dosage) – \(medication.instructions)"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay)
        
        // Repeat daily at selected time
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: medication.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelNotification(for medication: Medication) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [medication.id.uuidString]
        )
    }
    
    func rescheduleAll(for medications: [Medication]) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        medications.filter { $0.isActive }.forEach { scheduleNotification(for: $0) }
    }
}
