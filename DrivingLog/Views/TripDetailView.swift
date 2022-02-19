//
//  TripDetailView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//
import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    var body: some View {
        VStack {
            Text("Start Time: \(trip.startTime)")
                .font(.title3)
                .padding()
            Text("End Time: \(trip.endTime)")
                .font(.title3)
                .padding()
            Text("Supervisor: \(trip.supervisorName)")
                .font(.title3)
                .padding()
            Text("Other data?")
        }
        .navigationTitle("Trip detail")
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(trip: Trip(startTime: Date(), endTime: Date() + 60, supervisorName: "Alex"))
    }
}
