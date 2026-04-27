//
//  MapView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 20/4/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: LocationManager.bostonCoordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    @State private var selectedMakerspace: Makerspace?
    @State private var bottomSheetHeight: CGFloat = 200
    @GestureState private var dragOffset: CGFloat = 0
    
    private let minSheetHeight: CGFloat = 200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Map View
                Map(position: $position, selection: $selectedMakerspace) {
                    UserAnnotation()
                    
                    ForEach(viewModel.makerspaces) { makerspace in
                        Annotation(makerspace.name, coordinate: makerspace.coordinate) {
                            MapMarkerView(
                                makerspace: makerspace,
                                isSelected: selectedMakerspace?.id == makerspace.id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedMakerspace = makerspace
                                    bottomSheetHeight = geometry.size.height * 0.7
                                }
                            }
                        }
                        .tag(makerspace)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .ignoresSafeArea()
                
                // Bottom Sheet
                bottomSheet(geometry: geometry)
                    .frame(height: bottomSheetHeight + dragOffset)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: -5)
                    .offset(y: max(0, -dragOffset))
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation.height
                            }
                            .onEnded { value in
                                let snapDistance: CGFloat = 50
                                let velocity = value.predictedEndTranslation.height - value.translation.height
                                
                                withAnimation(.spring(response: 0.3)) {
                                    if value.translation.height < -snapDistance || velocity < -100 {
                                        // Swipe up - expand
                                        bottomSheetHeight = geometry.size.height * 0.7
                                    } else if value.translation.height > snapDistance || velocity > 100 {
                                        // Swipe down - collapse
                                        bottomSheetHeight = minSheetHeight
                                    }
                                }
                            }
                    )
            }
            .task {
                locationManager.requestPermission()
                await viewModel.fetchMakerspaces()
            }
            .onChange(of: locationManager.location?.latitude) { _, _ in
                updateMapPosition()
            }
            .onChange(of: locationManager.location?.longitude) { _, _ in
                updateMapPosition()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateMapPosition() {
        if let location = locationManager.location {
            position = .region(MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
    }
    
    // MARK: - Bottom Sheet
    
    private func bottomSheet(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            if let selected = selectedMakerspace {
                // Selected Makerspace Detail
                selectedMakerspaceView(selected, geometry: geometry)
            } else {
                // List of Makerspaces
                makerspaceListView(geometry: geometry)
            }
        }
    }
    
    private func selectedMakerspaceView(_ makerspace: Makerspace, geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Close button
                HStack {
                    Text("Details")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedMakerspace = nil
                            bottomSheetHeight = minSheetHeight
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                
                // Image
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [.makerYellow.opacity(0.3), .makerYellow.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 200)
                    
                    Image(systemName: "hammer.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.horizontal)
                
                // Info
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(makerspace.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if makerspace.isPopular {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.caption)
                                Text("Popular")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.makerYellow)
                            .cornerRadius(12)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.makerYellow)
                        Text(String(format: "%.1f", makerspace.rating))
                            .fontWeight(.semibold)
                        Text("(\(makerspace.reviewCount) reviews)")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.makerYellow)
                        Text(makerspace.address)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Price")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("$\(Int(makerspace.pricePerHour))/hr")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.makerYellow)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Navigate to booking
                        }) {
                            Text("Book Now")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color.makerYellow)
                                .cornerRadius(12)
                        }
                    }
                    
                    if !makerspace.amenities.isEmpty {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amenities")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(makerspace.amenities, id: \.self) { amenity in
                                    Text(amenity)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Recent Reviews Section
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Reviews")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button("See All") {
                                // Show all reviews
                            }
                            .font(.subheadline)
                            .foregroundStyle(.makerYellow)
                        }
                        
                        // Display reviews from posts
                        let reviews = Post.samples.filter { $0.makerspaceId == makerspace.id && $0.isReview }
                        
                        if reviews.isEmpty {
                            Text("No reviews yet. Be the first to review!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            ForEach(reviews.prefix(3)) { review in
                                MakerspaceReviewCard(review: review)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    private func makerspaceListView(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Nearby Makerspaces")
                    .font(.headline)
                
                Spacer()
                
                Text("\(viewModel.makerspaces.count) spaces")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.makerspaces) { makerspace in
                        MapListCard(makerspace: makerspace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedMakerspace = makerspace
                                    bottomSheetHeight = geometry.size.height * 0.7
                                    
                                    // Center map on selected makerspace
                                    position = .camera(MapCamera(
                                        centerCoordinate: makerspace.coordinate,
                                        distance: 1000,
                                        heading: 0,
                                        pitch: 0
                                    ))
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MapView()
}
