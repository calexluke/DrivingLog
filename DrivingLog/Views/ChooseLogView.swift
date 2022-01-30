//
//  ChooseLogView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ChooseLogView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Text("App Name Here")
                    .font(.title)
                Text("Also maybe an image")
                
                Spacer()
                
                // navigate to ProgressView with new DrivingLog object
                NavigationLink(
                    destination: ProgressView(drivingLog: MockDrivingLog()),
                    label: {
                        Text("Start New Log")
                            .modifier(ButtonModifier())
                    })
                
                Button("Load Existing Log") {
                    // navigate to list view of saved logs
                }
                .modifier(ButtonModifier())
                .padding()
            }
            .navigationTitle("Home Page")
        }
    }
}

struct ChooseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLogView()
    }
}
