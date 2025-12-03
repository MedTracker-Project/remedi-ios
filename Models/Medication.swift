//
//  Medication.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI

enum MedicationFrequency: String, Codable, CaseIterable, Identifiable {
    case onceDaily = "Once Daily"
    case twiceDaily = "Twice Daily"
    case threeTimesDaily = "Three Times Daily"
    
    var id: String { rawValue }
    
    var dosesPerDay: Int {
        switch self {
        case .onceDaily: return 1
        case .twiceDaily: return 2
        case .threeTimesDaily: return 3
        }
    }
}

struct Medication: Identifiable, Codable {
    let id: UUID
    var name: String
    var dosage: String
    var instructions: String
    var timeOfDay: Date
    var frequency: MedicationFrequency
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        dosage: String,
        instructions: String,
        timeOfDay: Date,
        frequency: MedicationFrequency,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.instructions = instructions
        self.timeOfDay = timeOfDay
        self.frequency = frequency
        self.isActive = isActive
    }
}

struct TakenDose: Identifiable, Codable {
    let id: UUID
    let medicationId: UUID
    let date: Date
    
    init(medicationId: UUID, date: Date = Date()) {
        self.id = UUID()
        self.medicationId = medicationId
        self.date = date
    }
}
