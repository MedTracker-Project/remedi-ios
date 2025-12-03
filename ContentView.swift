//
//  ContentView.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MedicationListView()
                .tabItem {
                    Label("Meds", systemImage: "pills.fill")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MedicationStore())
        .environmentObject(NotificationManager())
        .environmentObject(UserStatsStore())
}
