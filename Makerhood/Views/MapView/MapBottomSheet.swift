//
//  MapBottomSheet.swift
//  Makerhood
//
//  Created by Hyunjin Kim on 21/4/26.
//

import SwiftUI
import MapKit

struct MapBottomSheet: View {
    let geometry: GeometryProxy
    @Binding var selectedMakerspace: Makerspace?
    @Binding var bottomSheetHeight: CGFloat
    @Binding var position: MapCameraPosition
    let makerspaces: [Makerspace]
    let minSheetHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            if let selected = selectedMakerspace {
                // Selected Makerspace Detail
                MakerspaceDetailView(
                    makerspace: selected,
                    geometry: geometry,
                    selectedMakerspace: $selectedMakerspace,
                    bottomSheetHeight: $bottomSheetHeight,
                    minSheetHeight: minSheetHeight
                )
            } else {
                // List of Makerspaces
                MakerspaceListView(
                    makerspaces: makerspaces,
                    geometry: geometry,
                    selectedMakerspace: $selectedMakerspace,
                    bottomSheetHeight: $bottomSheetHeight,
                    position: $position
                )
            }
        }
    }
}
