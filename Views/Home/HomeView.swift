//
//  HomeView.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @EnvironmentObject var userStats: UserStatsStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                PillyHeaderView()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today’s Medications")
                        .font(.headline)
                    
                    if medicationStore.medications.isEmpty {
                        Text("No medications added yet.\nGo to the Meds tab to get started.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        List {
                            ForEach(medicationStore.medications.filter { $0.isActive }) { med in
                                TodayMedicationRow(medication: med)
                            }
                        }
                        .listStyle(.insetGrouped)
                        .frame(maxHeight: 320)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Remedi")
            .onAppear {
                notificationManager.rescheduleAll(for: medicationStore.medications)
            }
        }
    }
}

struct PillyHeaderView: View {
    @EnvironmentObject var userStats: UserStatsStore
    
    var body: some View {
        VStack(spacing: 12) {
            // Simple “mascot” circle – you can later replace with an asset.
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 120, height: 120)
                VStack(spacing: 4) {
                    Text("💊")
                        .font(.system(size: 48))
                    Text("Pilly")
                        .font(.headline)
                }
            }
            
            Text(pillyMessage)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack(spacing: 24) {
                VStack {
                    Text("\(userStats.totalPoints)")
                        .font(.title).bold()
                    Text("Points")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                VStack {
                    Text("\(userStats.streakDays)")
                        .font(.title).bold()
                    Text("Day Streak")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var pillyMessage: String {
        if userStats.streakDays >= 7 {
            return "Amazing streak! Pilly is proud of you. Keep it going! 🌟"
        } else if userStats.streakDays >= 1 {
            return "Nice work staying on track. Let’s keep your streak alive! 💪"
        } else {
            return "Hi! I’m Pilly. Add your meds and I’ll help you remember them. 😊"
        }
    }
}

struct TodayMedicationRow: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @EnvironmentObject var userStats: UserStatsStore
    
    let medication: Medication
    
    var body: some View {
        let dosesTaken = medicationStore.dosesTakenToday(for: medication)
        let remaining = max(medication.frequency.dosesPerDay - dosesTaken, 0)
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.headline)
                
                if !medication.instructions.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text(medication.instructions)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text(medication.dosage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Remaining today: \(remaining)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Button {
                guard remaining > 0 else { return }
                medicationStore.markDoseTaken(for: medication)
                userStats.awardPointsForDose()
            } label: {
                Text(remaining > 0 ? "Mark Taken" : "All Done")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(remaining > 0 ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .disabled(remaining == 0)
        }
    }
}
