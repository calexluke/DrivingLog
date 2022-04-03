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
