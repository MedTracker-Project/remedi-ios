//
//  RemediApp.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI

@main
struct RemediApp: App {
    @StateObject private var medicationStore = MedicationStore()
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var userStats = UserStatsStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(medicationStore)
                .environmentObject(notificationManager)
                .environmentObject(userStats)
                .onAppear {
                    notificationManager.requestAuthorization()
                }
        }
    }
}
