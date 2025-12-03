//
//  MedicationStore.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI
internal import Combine

final class MedicationStore: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var takenDoses: [TakenDose] = []
    
    private let medsKey = "remedi_medications"
    private let dosesKey = "remedi_taken_doses"
    
    init() {
        load()
    }
    
    func addMedication(_ med: Medication) {
        medications.append(med)
        save()
    }
    
    func updateMedication(_ med: Medication) {
        guard let idx = medications.firstIndex(where: { $0.id == med.id }) else { return }
        medications[idx] = med
        save()
    }
    
    func deleteMedication(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        save()
    }
    
    func markDoseTaken(for medication: Medication) {
        let dose = TakenDose(medicationId: medication.id)
        takenDoses.append(dose)
        save()
    }
    
    func dosesTakenToday(for medication: Medication) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return takenDoses.filter {
            $0.medicationId == medication.id &&
            calendar.isDate($0.date, inSameDayAs: today)
        }.count
    }
    
    // MARK: - Persistence
    
    private func save() {
        do {
            let medsData = try JSONEncoder().encode(medications)
            UserDefaults.standard.set(medsData, forKey: medsKey)
            
            let doseData = try JSONEncoder().encode(takenDoses)
            UserDefaults.standard.set(doseData, forKey: dosesKey)
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    private func load() {
        let decoder = JSONDecoder()
        
        if let medsData = UserDefaults.standard.data(forKey: medsKey),
           let decodedMeds = try? decoder.decode([Medication].self, from: medsData) {
            medications = decodedMeds
        }
        
        if let doseData = UserDefaults.standard.data(forKey: dosesKey),
           let decodedDoses = try? decoder.decode([TakenDose].self, from: doseData) {
            takenDoses = decodedDoses
        }
    }
    
    func streakForMedication(_ medication: Medication) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // All doses ever taken for this medication
        let medDoses = takenDoses.filter { $0.medicationId == medication.id }
        if medDoses.isEmpty { return 0 }
        
        var streak = 0
        var dayOffset = 0
        
        while true {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { break }
            
            // How many doses were taken on this specific day?
            let dosesOnDay = medDoses.filter { dose in
                calendar.isDate(dose.date, inSameDayAs: date)
            }.count
            
            let requiredDoses = medication.frequency.dosesPerDay
            
            if dosesOnDay >= requiredDoses {
                // User took all required doses this day
                streak += 1
                dayOffset += 1
            } else {
                // As soon as we hit a day where they did NOT complete all doses,
                // the streak stops.
                break
            }
        }
        
        return streak
    }

}
