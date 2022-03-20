//
//  TripListView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct TripListView: View {
    
    @ObservedObject var drivingLog: DrivingLog
    @State var showAddTripSheet = false
    let logsManager = DrivingLogsManager.sharedInstance
    let pdfManager = PDFManager()
    
    var body: some View {
        List() {
            ForEach(drivingLog.trips) { trip in
                NavigationLink(
                    destination: TripDetailView(drivingLog: drivingLog, trip: trip),
                    label: {
                        Text("Start time: \(trip.startTime)")
                    })
            }
            .onDelete(perform: delete)
            
        }
        .navigationTitle("List of Trips")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddTripSheet = true
                    print("Add trip tapped!")
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddTripSheet, content: {
            AddNewTripView(drivingLog: drivingLog)
        })
    }
    
    func delete(at offsets: IndexSet) {
        drivingLog.trips.remove(atOffsets: offsets)
        logsManager.updateAndSaveLogsList(with: drivingLog)
        DispatchQueue.global(qos: .default).async {
            pdfManager.writeTripDataToPDF(for: drivingLog.trips, id: drivingLog.id)
        }
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView(drivingLog: MockDrivingLog())
    }
}
