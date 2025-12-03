//
//  MedicationListView.swift
//  Remedi
//
//  Created by Jorge Jesus Diaz Jr on 12/2/25.
//

import SwiftUI

struct MedicationListView: View {
    @EnvironmentObject var medicationStore: MedicationStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var showingAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(medicationStore.medications) { med in
                    NavigationLink {
                        AddOrEditMedicationView(existingMedication: med)
                    } label: {
                        MedicationRow(medication: med)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Medications")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    AddOrEditMedicationView()
                }
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        let medsToDelete = offsets.map { medicationStore.medications[$0] }
        medsToDelete.forEach { notificationManager.cancelNotification(for: $0) }
        medicationStore.deleteMedication(at: offsets)
    }
}

import SwiftUI

struct MedicationRow: View {
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Name
            Text(medication.name)
                .font(.headline)
            
            // Instructions (only if not empty)
            if !medication.instructions.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(medication.instructions)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Dosage & frequency
            Text(medication.dosage)
                .font(.subheadline)
            
            Text(medication.frequency.rawValue)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
