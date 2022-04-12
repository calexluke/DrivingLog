//
//  TripListView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct TripListView: View {
    
    //Initializing variables and constants needed for the TripListView
    @ObservedObject var drivingLog: DrivingLog
    @State var showAddTripSheet = false
    let logsManager = DrivingLogsManager.sharedInstance
    let pdfManager = PDFManager()
    
    //Formatting the date appropriately, so that it is in a format that the user is familiar with
    private let listCellDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    //This is the stuff that the user will see when they get to the Trip List screen
    var body: some View {
        
        //Displaying all of the trips
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
        
        //UI design related
        .padding([.top])
        .background(
            Theme.secondaryBackgroundColor
                .ignoresSafeArea()
        )
        
        .navigationTitle("Saved Trips")
        
        //Toolbar created at the top to either add a trip or to go back to the Overall Progress screen
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
    
    /// This function returns a welcoming string for a given `subject`.
    /// - Parameter offsets: The rest of the trips will be shifted by these values in the view.
    func delete(at offsets: IndexSet) {
        drivingLog.trips.remove(atOffsets: offsets)
        logsManager.updateAndSaveLogsList(with: drivingLog)
        DispatchQueue.global(qos: .default).async {
            pdfManager.writeTripDataToPDF(for: drivingLog.trips, id: drivingLog.id)
        }
    }
}

//This works to produce a view preview of the Trip List in the Xcode IDE
struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView(drivingLog: MockDrivingLog())
    }
}
