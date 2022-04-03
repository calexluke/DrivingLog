//
//  MapView.swift
//  DrivingLog
//
//  Created by Thomas Hohnholt on 2/22/22.
//
import SwiftUI
import MapKit
import CoreLocation


struct MapView: View {
    
    @StateObject var viewModel: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Theme.accentColor)
            .gesture(
                DragGesture()
                    .onChanged( { _ in
                        // disable auto centering when user scrolls on map
                        viewModel.autoCenteringEnabled = false
                    })
            )
            .gesture(
                MagnificationGesture()
                    .onChanged( { _ in
                        // disable auto centering when user zooms on map
                        viewModel.autoCenteringEnabled = false
                    })
            )
            .onAppear {
                viewModel.checkIfLocationIsEnabled()
            }
    }
    
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}
