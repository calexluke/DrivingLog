//
//  TripDetailView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//
import SwiftUI
import MapKit

struct TripDetailView: View {
    
    @ObservedObject var drivingLog: DrivingLog
    @State var trip: Trip
    let logsManager = DrivingLogsManager.sharedInstance
    //Fake data/coordinates until 3.2 gets done

    
    var body: some View {
        VStack {
            
            Spacer()
            tripRouteView()
            
            Spacer()
            
            Text("Supervisor: \(trip.supervisorName)")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title3)
                .padding()
            
            EditTripView(drivingLog: drivingLog, trip: trip)
        }
        .background(
            Theme.appBackgroundColor
                .ignoresSafeArea()
        )
        .navigationTitle("Trip detail")
    }
    
    @ViewBuilder
    func tripRouteView() -> some View {
        if trip.route.isEmpty {
            Text("No route information available")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title2)
        } else {
            LineMapView(mapViewModel: mapViewModelFromTrip())
              .ignoresSafeArea(edges: .top)
              .frame(height: 300)
        }
    }
    
    func mapViewModelFromTrip() -> MapViewModel {
        guard let startingLocation = trip.route.first else {
            return MapViewModel()
        }
        let startingLocationCL = CLLocationCoordinate2D(latitude: startingLocation.latitude,
                                                longitude: startingLocation.longitude)
        let region = MKCoordinateRegion(center: startingLocationCL, span: MapDetails.defaultSpan)
        let viewModel = MapViewModel(region: region, route: trip.route)
        viewModel.populateCLCoords()
        return viewModel
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(drivingLog: MockDrivingLog(), trip: MockDrivingLog().trips.first!)
    }
}
