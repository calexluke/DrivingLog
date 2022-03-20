//
//  TripDetailView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//
import SwiftUI

struct TripDetailView: View {
    
    @ObservedObject var drivingLog: DrivingLog
    @State var trip: Trip
    
    var body: some View {
        VStack {
            Text("Map view here")
                .font(.title3)
                .padding()
            
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
