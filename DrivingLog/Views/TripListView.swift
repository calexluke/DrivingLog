//
//  TripListView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct TripListView: View {
    
    @ObservedObject var drivingLog: DrivingLog
    var logsManager = DrivingLogsManager.sharedInstance
    
    var body: some View {
        List() {
            ForEach(drivingLog.trips) { trip in
                NavigationLink(
                    destination: TripDetailView(trip: trip),
                    label: {
                        Text("Start time: \(trip.startTime)")
                    })
            }
            .onDelete(perform: delete)
            
        }
        .navigationTitle("List of Trips")
    }
    
    func delete(at offsets: IndexSet) {
        drivingLog.trips.remove(atOffsets: offsets)
        logsManager.updateAndSaveLogsList(with: drivingLog)
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView(drivingLog: MockDrivingLog())
    }
}
