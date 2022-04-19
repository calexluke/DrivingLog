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
    @StateObject var mapViewModel = MapViewModel()
    @ObservedObject var cloudViewModel = CloudViewModel.sharedInstance
    @State var trip: Trip

    let logsManager = DrivingLogsManager.sharedInstance
    let cloudManager = CloudManager()
    
    //Initializing a Driving Log object and a Trip object, both of which are needed for this view to function
    init(drivingLog: DrivingLog, selectedTrip: Trip) {
        self.drivingLog = drivingLog
        _trip = State<Trip>.init(initialValue: selectedTrip)
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
        .onAppear {
            cloudManager.fetchTrip(id: trip.id, completionHandler: onTripFetched(fetchedTrip:error:))
        }
        
        //Working with UI design
        .background(
            Theme.appBackgroundColor
                .ignoresSafeArea()
        )
        .navigationTitle("Trip detail")
    }
    
    func onTripFetched(fetchedTrip: Trip?, error: Error?) {
        guard error == nil else {
            DispatchQueue.main.async {
                cloudViewModel.tripErrorMessage = error!.localizedDescription
                cloudViewModel.fetchTripError = true
            }
            print(error!.localizedDescription)
            return
        }
        
        guard let fetchedTrip = fetchedTrip else {
            return
        }
        DispatchQueue.main.async {
            trip = fetchedTrip
            mapViewModel.locations = fetchedTrip.locations
            mapViewModel.centerMapOnStartingLocation()
            print("finished fetching trip. start time: \(fetchedTrip.startTime), supervisor: \(fetchedTrip.supervisorName)")
            print(fetchedTrip.locations)
        }
    }
    
    @ViewBuilder
    /// This function returns a view depending on whether or not there is a route associated with a particular trip.
    /// - Returns: A view either with or without the trip route, depending on if there is a route in the trip object.
    func tripRouteView() -> some View {
        if !trip.hasLocationData {
            Text("No route information available")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title2)
        } else {
            LineMapView(mapViewModel: mapViewModel)
              .ignoresSafeArea(edges: .top)
              .frame(height: 300)
              .alert(isPresented: $cloudViewModel.fetchTripError) {
                  fetchTripErrorAlert()
              }
        }
    }
    
    func fetchTripErrorAlert() -> Alert {
        return Alert(
            title: Text("Error fetching trip location data from iCloud"),
            message: Text(cloudViewModel.tripErrorMessage),
            dismissButton: .default(Text("OK"))
        )
    }
}

//This works to produce a view preview of a Trip Detail View in the Xcode IDE
struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(drivingLog: MockDrivingLog(), selectedTrip: MockDrivingLog().trips.first!)
    }
}
