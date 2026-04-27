//
//  EditMakerspaceProfileView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 23/4/26.
//

import SwiftUI

struct EditMakerspaceProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    let makerspace: Makerspace
    let onSave: (Makerspace) -> Void
    
    @State private var name: String
    @State private var description: String
    @State private var address: String
    @State private var pricePerHour: String
    @State private var amenities: [String]
    @State private var newAmenity: String = ""
    @State private var showingAddAmenity = false
    
    init(makerspace: Makerspace, onSave: @escaping (Makerspace) -> Void) {
        self.makerspace = makerspace
        self.onSave = onSave
        
        _name = State(initialValue: makerspace.name)
        _description = State(initialValue: makerspace.description)
        _address = State(initialValue: makerspace.address)
        _pricePerHour = State(initialValue: String(format: "%.0f", makerspace.pricePerHour))
        _amenities = State(initialValue: makerspace.amenities)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Basic Information
                Section("Basic Information") {
                    TextField("Makerspace Name", text: $name)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    TextField("Address", text: $address, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                // Pricing
                Section("Pricing") {
                    HStack {
                        Text("$")
                        TextField("Price per hour", text: $pricePerHour)
                            .keyboardType(.decimalPad)
                        Text("/hour")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Amenities
                Section {
                    ForEach(amenities, id: \.self) { amenity in
                        HStack {
                            Text(amenity)
                            Spacer()
                            Button(role: .destructive) {
                                if let index = amenities.firstIndex(of: amenity) {
                                    amenities.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    Button {
                        showingAddAmenity = true
                    } label: {
                        Label("Add Amenity", systemImage: "plus.circle.fill")
                            .foregroundStyle(.makerYellow)
                    }
                } header: {
                    Text("Amenities & Equipment")
                } footer: {
                    Text("Add equipment and facilities available at your makerspace")
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
            .alert("Add Amenity", isPresented: $showingAddAmenity) {
                TextField("Equipment name", text: $newAmenity)
                Button("Cancel", role: .cancel) {
                    newAmenity = ""
                }
                Button("Add") {
                    if !newAmenity.isEmpty {
                        amenities.append(newAmenity)
                        newAmenity = ""
                    }
                }
            } message: {
                Text("Enter the name of equipment or facility")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !description.isEmpty &&
        !address.isEmpty
    }
    
    private func saveChanges() {
        let price = Double(pricePerHour) ?? 0.0
        
        let updatedMakerspace = Makerspace(
            id: makerspace.id,
            name: name,
            description: description,
            address: address,
            latitude: makerspace.latitude, // Keep existing coordinates
            longitude: makerspace.longitude, // Keep existing coordinates
            imageURL: makerspace.imageURL,
            organizationId: makerspace.organizationId,
            amenities: amenities,
            pricePerHour: price,
            rating: makerspace.rating,
            reviewCount: makerspace.reviewCount,
            isPopular: makerspace.isPopular,
            createdAt: makerspace.createdAt
        )
        
        onSave(updatedMakerspace)
        dismiss()
    }
}

#Preview {
    EditMakerspaceProfileView(makerspace: .sample) { _ in }
}
