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
    @State private var latitude: String
    @State private var longitude: String
    @State private var imageURL: String
    
    init(makerspace: Makerspace, onSave: @escaping (Makerspace) -> Void) {
        self.makerspace = makerspace
        self.onSave = onSave
        
        _name = State(initialValue: makerspace.name)
        _description = State(initialValue: makerspace.description)
        _address = State(initialValue: makerspace.address)
        _latitude = State(initialValue: String(makerspace.latitude))
        _longitude = State(initialValue: String(makerspace.longitude))
        _imageURL = State(initialValue: makerspace.imageURL ?? "")
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
                    
                    // Location
                    Section("Location Coordinates") {
                        TextField("Latitude", text: $latitude)
                            .keyboardType(.decimalPad)
                        
                        TextField("Longitude", text: $longitude)
                            .keyboardType(.decimalPad)
                    }
                    
                    // Media
                    Section("Media") {
                        TextField("Image URL", text: $imageURL)
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
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
        }
    }
    
    // MARK: - Helper Methods
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !description.isEmpty &&
        !address.isEmpty &&
        isValidCoordinate(latitude) &&
        isValidCoordinate(longitude)
    }
    
    private func isValidCoordinate(_ value: String) -> Bool {
        // Check if it's a valid double
        return Double(value) != nil
    }
    
    private func saveChanges() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            return
        }
        
        let updatedMakerspace = Makerspace(
            id: makerspace.id,
            name: name,
            description: description,
            address: address,
            latitude: lat,
            longitude: lon,
            imageURL: imageURL.isEmpty ? nil : imageURL,
            websiteURL: makerspace.websiteURL,
            organizationId: makerspace.organizationId,
            createdAt: makerspace.createdAt
        )
        
        onSave(updatedMakerspace)
        dismiss()
    }
}

#Preview {
    EditMakerspaceProfileView(makerspace: .sample) { _ in }
}
