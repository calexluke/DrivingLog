//
//  TripInProgressView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct TripInProgressView: View {
    var drivingLog: DrivingLog
    
    var body: some View {
        Text("New Trip In Progress")
    }
}

struct TripInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TripInProgressView(drivingLog: MockDrivingLog())
    }
}
