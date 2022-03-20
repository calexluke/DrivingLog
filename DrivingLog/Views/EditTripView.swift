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
    var drivingLog: DrivingLog
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
            }
            .padding(.leading)
            .padding(.trailing)
            
            DatePicker(selection: $trip.endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("End Time:")
            }
            .padding([.leading, .trailing, .bottom])
            
            Button("Save Changes") {
                drivingLog.editTrip(tripWithChanges: trip)
                logsManager.updateAndSaveLogsList(with: drivingLog)
                
            }
            .modifier(ButtonModifier())
        }
    }
}

