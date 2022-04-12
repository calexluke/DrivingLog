//
//  TripDetailView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//
import SwiftUI
import MapKit

struct TripDetailView: View {
    
    //Initializing all of the variables and constants necessary for the Trip Detail View
    @ObservedObject var drivingLog: DrivingLog
    @ObservedObject var mapViewModel = MapViewModel()
    @State var trip: Trip
    let logsManager = DrivingLogsManager.sharedInstance
    
    //Initializing a Driving Log object and a Trip object, both of which are needed for this view to function
    init(drivingLog: DrivingLog, selectedTrip: Trip) {
        self.drivingLog = drivingLog
        _trip = State<Trip>.init(initialValue: selectedTrip)
        setMapViewModel()
    }
    
    //This is what the user will see when they load up the Trip Detail View
    var body: some View {
        VStack {
            
            Spacer()
            
            //Displaying the trip route
            tripRouteView()
            
            Spacer()
            
            //Displaying supervisor information
            Text("Supervisor: \(trip.supervisorName)")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title3)
                .padding()
            
            EditTripView(drivingLog: drivingLog, trip: trip)
        }
        
        //Working with UI design
        .background(
            Theme.appBackgroundColor
                .ignoresSafeArea()
        )
        .navigationTitle("Trip detail")
    }
    
    @ViewBuilder
    /// This function returns a view depending on whether or not there is a route associated with a particular trip.
    /// - Returns: A view either with or without the trip route, depending on if there is a route in the trip object.
    func tripRouteView() -> some View {
        if trip.route.isEmpty {
            Text("No route information available")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title2)
        } else {
            //LineMapView(mapViewModel: mapViewModelFromTrip())
            LineMapView(mapViewModel: mapViewModel)
              .ignoresSafeArea(edges: .top)
              .frame(height: 300)
        }
    }
    
    /// This function sets the Map View Model to have an appropriate location center, region, and polyline.
    func setMapViewModel() {
        guard let startingLocation = trip.route.first else {
            return
        }
        
        //Centering the map on the appropriate location center, region, and polyline
        DispatchQueue.global(qos: .default).async {
            let startingLocationCL = CLLocationCoordinate2D(latitude: startingLocation.latitude,
                                                    longitude: startingLocation.longitude)
            let region = MKCoordinateRegion(center: startingLocationCL, span: MapDetails.defaultSpan)
            let route = trip.route
            
            DispatchQueue.main.async {
                self.mapViewModel.region = region
                self.mapViewModel.route = route
                self.mapViewModel.populateCLCoords()
            }
        }
    }
    
    /// This function returns a MapViewModel which is created and set up by the function itself.
    /// - Returns: A MapViewModel which has everything set up as necessary, such as the center, region, etc.
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

//This works to produce a view preview of a Trip Detail View in the Xcode IDE
struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(drivingLog: MockDrivingLog(), selectedTrip: MockDrivingLog().trips.first!)
    }
}
