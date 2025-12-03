//
//  UserStatsStore.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI
internal import Combine

final class UserStatsStore: ObservableObject {
    @Published var totalPoints: Int = 0
    @Published var streakDays: Int = 0
    
    private let pointsKey = "user_stats_points"
    private let streakKey = "user_stats_streak"
    private let lastTakenDateKey = "user_stats_last_taken_date"
    
    private var lastTakenDate: Date? {
        didSet {
            if let date = lastTakenDate {
                UserDefaults.standard.set(date, forKey: lastTakenDateKey)
            }
        }
    }
    
    init() {
        totalPoints = UserDefaults.standard.integer(forKey: pointsKey)
        streakDays = UserDefaults.standard.integer(forKey: streakKey)
        lastTakenDate = UserDefaults.standard.object(forKey: lastTakenDateKey) as? Date
    }
    
    func awardPointsForDose() {
        // Simple system: +10 points per dose taken
        totalPoints += 10
        UserDefaults.standard.set(totalPoints, forKey: pointsKey)
        
        updateStreak()
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let last = lastTakenDate {
            let lastDay = calendar.startOfDay(for: last)
            if let diff = calendar.dateComponents([.day], from: lastDay, to: today).day {
                switch diff {
                case 0:
                    // same day, keep streak as-is
                    break
                case 1:
                    // consecutive day
                    streakDays += 1
                default:
                    // streak broken
                    streakDays = 1
                }
            }
        } else {
            streakDays = 1
        }
        
        lastTakenDate = Date()
        UserDefaults.standard.set(streakDays, forKey: streakKey)
    }
}
