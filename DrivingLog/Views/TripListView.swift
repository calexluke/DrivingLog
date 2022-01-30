//
//  TripListView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct TripListView: View {
    
    var drivingLog: DrivingLog
    
    var body: some View {
        List(drivingLog.trips) { trip in
            NavigationLink(
                destination: TripDetailView(trip: trip),
                label: {
                    Text("Start time: \(trip.startTime)")
                })
        }
        .navigationTitle("List of Trips")
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView(drivingLog: MockDrivingLog())
    }
}
