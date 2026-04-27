//
//  MakerspaceListView.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI
import MapKit

struct MakerspaceListView: View {
    let makerspaces: [Makerspace]
    let geometry: GeometryProxy
    @Binding var selectedMakerspace: Makerspace?
    @Binding var bottomSheetHeight: CGFloat
    @Binding var position: MapCameraPosition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Nearby Makerspaces")
                    .font(.headline)
                
                Spacer()
                
                Text("\(makerspaces.count) spaces")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(makerspaces) { makerspace in
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
