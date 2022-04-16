//
//  EditTripView.swift
//  DrivingLog
//
//  Created by Alex Luke on 3/19/22.
//

import Foundation
import SwiftUI

struct EditTripView: View {
    
    let logsManager = DrivingLogsManager.sharedInstance
    let cloudManager = CloudManager()
    let pdfManager = PDFManager()
    @ObservedObject var drivingLog: DrivingLog
    @State var trip: Trip
    
    //This formats the date and time
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack {
            //Date picker with previous data in it which can be edited
            DatePicker(selection: $trip.startTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("Start Time:")
                    .foregroundColor(Theme.primaryTextColor)
            }
            .padding(.leading)
            .padding(.trailing)
            //Date picker with previous data in it which can be edited
            DatePicker(selection: $trip.endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("End Time:")
                    .foregroundColor(Theme.primaryTextColor)
            }
            .padding([.leading, .trailing, .bottom])
            
            //Button to save changes
            Button("Save Changes") {
                drivingLog.editTrip(tripWithChanges: trip)
                logsManager.updateAndSaveLogsList(with: drivingLog)
                DispatchQueue.global(qos: .default).async {
                    pdfManager.writeTripDataToPDF(for: drivingLog.trips, id: drivingLog.id)
                    cloudManager.saveTrip(trip)
                }
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
        }
    }
}

