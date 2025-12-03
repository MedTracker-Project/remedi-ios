//
//  AddOrEditMedicationView.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI

struct AddOrEditMedicationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var medicationStore: MedicationStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var instructions: String = ""
    @State private var timeOfDay: Date = Date()
    @State private var frequency: MedicationFrequency = .onceDaily
    @State private var isActive: Bool = true
    
    let existingMedication: Medication?
    
    init(existingMedication: Medication? = nil) {
        self.existingMedication = existingMedication
    }
    
    var body: some View {
        Form {
            Section(header: Text("Medication Info")) {
                TextField("Name", text: $name)
                TextField("Dosage (e.g., 10mg)", text: $dosage)
                TextField("Instructions (e.g., with food)", text: $instructions)
            }
            
            Section(header: Text("Schedule")) {
                DatePicker("Reminder Time", selection: $timeOfDay, displayedComponents: .hourAndMinute)
                
                Picker("Frequency", selection: $frequency) {
                    ForEach(MedicationFrequency.allCases) { freq in
                        Text(freq.rawValue).tag(freq)
                    }
                }
                
                Toggle("Active", isOn: $isActive)
            }
        }
        .navigationTitle(existingMedication == nil ? "Add Medication" : "Edit Medication")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveMedication()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .onAppear(perform: loadExisting)
    }
    
    private func loadExisting() {
        guard let med = existingMedication else { return }
        name = med.name
        dosage = med.dosage
        instructions = med.instructions
        timeOfDay = med.timeOfDay
        frequency = med.frequency
        isActive = med.isActive
    }
    
    private func saveMedication() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        
        if var med = existingMedication {
            med.name = trimmedName
            med.dosage = dosage
            med.instructions = instructions
            med.timeOfDay = timeOfDay
            med.frequency = frequency
            med.isActive = isActive
            
            medicationStore.updateMedication(med)
            if isActive {
                notificationManager.scheduleNotification(for: med)
            } else {
                notificationManager.cancelNotification(for: med)
            }
        } else {
            let med = Medication(
                name: trimmedName,
                dosage: dosage,
                instructions: instructions,
                timeOfDay: timeOfDay,
                frequency: frequency,
                isActive: isActive
            )
            medicationStore.addMedication(med)
            
            if isActive {
                notificationManager.scheduleNotification(for: med)
            }
        }
        
        dismiss()
    }
}
