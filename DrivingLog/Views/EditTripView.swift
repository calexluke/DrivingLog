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
    @ObservedObject var drivingLog: DrivingLog
    @State var trip: Trip
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack {
            DatePicker(selection: $trip.startTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("Start Time:")
                    .foregroundColor(Theme.primaryTextColor)
            }
            .padding(.leading)
            .padding(.trailing)
            
            DatePicker(selection: $trip.endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("End Time:")
                    .foregroundColor(Theme.primaryTextColor)
            }
            .padding([.leading, .trailing, .bottom])
            
            Button("Save") {
                drivingLog.editTrip(tripWithChanges: trip)
                logsManager.updateAndSaveLogsList(with: drivingLog)
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
        }
    }
}

