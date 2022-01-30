//
//  ProgressView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ProgressView: View {
    @State var newTripSheetIsPresented = false
    
    var drivingLog: DrivingLog
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Progress Bar Here")
                .font(.title)
            Text("and other data?")
            Spacer()
            
            NavigationLink(
                destination: TripListView(drivingLog: drivingLog),
                label: {
                    Text("View Saved Trips")
                        .modifier(ButtonModifier())
                })
            
            Button("Start New Trip") {
                newTripSheetIsPresented.toggle()
            }
            .modifier(ButtonModifier())
            .padding()
        }
        .sheet(isPresented: $newTripSheetIsPresented, content: {
            TripInProgressView(drivingLog: drivingLog)
        })
        .navigationTitle("Overall Progress")
    }
}

struct ProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressView(drivingLog: MockDrivingLog())
    }
}
