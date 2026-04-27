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
    @State private var shouldFollowUserLocation = false
    
    private let minSheetHeight: CGFloat = 200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Map View
                Map(position: $position, selection: $selectedMakerspace) {
                    // Only show user annotation if we have actual location permission
                    if locationManager.authorizationStatus == .authorizedWhenInUse ||
                       locationManager.authorizationStatus == .authorizedAlways {
                        UserAnnotation()
                    }
                    
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
                    MapCompass()
                    MapScaleView()
                }
                .safeAreaInset(edge: .trailing) {
                    VStack(spacing: 12) {
                        // Custom user location button
                        Button(action: {
                            shouldFollowUserLocation = true
                            updateMapPosition()
                        }) {
                            Image(systemName: shouldFollowUserLocation ? "location.fill" : "location")
                                .font(.system(size: 20))
                                .foregroundStyle(shouldFollowUserLocation ? .makerYellow : .primary)
                                .frame(width: 44, height: 44)
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 16)
                    }
                }
                .ignoresSafeArea()
                
                // Bottom Sheet
                bottomSheet(geometry: geometry)
                    .frame(height: max(minSheetHeight, bottomSheetHeight + dragOffset))
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
                // Immediately set to Boston before any async operations
                position = .region(MKCoordinateRegion(
                    center: LocationManager.bostonCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
                
                await viewModel.fetchMakerspaces()
                
                // Debug: Print makerspace locations
                print("📍 Loaded \(viewModel.makerspaces.count) makerspaces")
                for space in viewModel.makerspaces.prefix(3) {
                    print("📍 \(space.name): \(space.latitude), \(space.longitude)")
                }
                
                locationManager.requestPermission()
            }
            .onChange(of: locationManager.location?.latitude) { _, _ in
                if shouldFollowUserLocation {
                    updateMapPosition()
                }
            }
            .onChange(of: locationManager.location?.longitude) { _, _ in
                if shouldFollowUserLocation {
                    updateMapPosition()
                }
            }
            .onMapCameraChange { context in
                // If user manually pans the map, stop following their location
                shouldFollowUserLocation = false
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateMapPosition() {
        guard shouldFollowUserLocation else {
            print("🗺️ Not following user location, staying on current position")
            return
        }
        
        let location = locationManager.location ?? LocationManager.bostonCoordinate
        let locationSource = locationManager.location != nil ? "user location" : "default (Boston)"
        print("🗺️ Updating map position to \(locationSource): \(location.latitude), \(location.longitude)")
        
        withAnimation {
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
                        
                    }
                    
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.makerYellow)
                        Text(makerspace.address)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    
                    // Recent Reviews Section
                    Divider()
                
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

#Preview("Map View") {
    MapView()
}

// Note: Xcode Previews may initially show Cupertino due to the preview environment's
// default location simulation. The actual app in the simulator will correctly show Boston.
// To test different locations in previews, use the simulator instead.


