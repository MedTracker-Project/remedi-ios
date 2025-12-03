//
//  StatsView.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var userStats: UserStatsStore
    @EnvironmentObject var medicationStore: MedicationStore
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Overall progress header
                VStack {
                    Text("Your Progress")
                        .font(.title2)
                        .bold()
                    Text("Keep building healthy medication habits.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // Overall stats (you can keep using global streak if you like)
                HStack(spacing: 24) {
                    StatCard(title: "Points", value: "\(userStats.totalPoints)")
                    StatCard(title: "Overall Streak", value: "\(userStats.streakDays) days")
                }
                
                // Per-medication streaks
                VStack(alignment: .leading, spacing: 8) {
                    Text("Medication Streaks")
                        .font(.headline)
                    
                    if medicationStore.medications.isEmpty {
                        Text("You don't have any medications yet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(medicationStore.medications.filter { $0.isActive }) { med in
                            let streak = medicationStore.streakForMedication(med)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(med.name)
                                        .font(.subheadline)
                                    Text(med.frequency.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(streak) day\(streak == 1 ? "" : "s")")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Stats")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
