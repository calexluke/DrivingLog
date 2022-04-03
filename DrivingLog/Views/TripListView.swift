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
    
    private let listCellDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        List() {
            ForEach(drivingLog.trips) { trip in
                ZStack {
                    HStack {
                        Text(trip.startTime, formatter: listCellDateFormatter)
                            .foregroundColor(Theme.primaryTextColor)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.accentColor)
                    }
                    NavigationLink(
                        destination: TripDetailView(drivingLog: drivingLog, selectedTrip: trip)) {
                        }.buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0)
                }
            }
            
            .onDelete(perform: delete)
            .listRowBackground(Theme.appBackgroundColor)
            
        }
        .padding([.top])
        .background(
            Theme.secondaryBackgroundColor
                .ignoresSafeArea()
        )
        
        .navigationTitle("Saved Trips")
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
