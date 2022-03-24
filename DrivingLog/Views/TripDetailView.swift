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
    
    @State private var region = MKCoordinateRegion(
        // Apple Park
        center: CLLocationCoordinate2D(latitude: 37.334803, longitude: -122.008965),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
      )
    @State private var lineCoordinates = [

        // Steve Jobs theatre
        CLLocationCoordinate2D(latitude: 37.330828, longitude: -122.007495),

        // Caffè Macs
        CLLocationCoordinate2D(latitude: 37.336083, longitude: -122.007356),

        // Apple wellness center
        CLLocationCoordinate2D(latitude: 37.336901, longitude:  -122.012345)
      ];
    var body: some View {
        VStack {
            LineMapView(
                region: region,
                lineCoordinates: lineCoordinates)
              .ignoresSafeArea(edges: .top)
              .frame(height: 300)
            
            Spacer()
            
            Text("Supervisor: \(trip.supervisorName)")
                .font(.title3)
                .padding()
            Text("Other data?")
            
            Spacer()
            
            EditTripView(drivingLog: drivingLog, trip: trip)
        }
        .navigationTitle("Trip detail")
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(drivingLog: MockDrivingLog(), trip: MockDrivingLog().trips.first!)
    }
}
