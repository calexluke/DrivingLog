//
//  ChooseLogView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ChooseLogView: View {
    
    let logsManager = DrivingLogsManager.sharedInstance
    @State var selectedLog: DrivingLog?
    @State var userDidSelectLog = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Text("App Name Here")
                    .font(.title)
                Text("Also maybe an image")
                
                Spacer()
                
                // navigate to ProgressView with new DrivingLog object
                // TODO: have user enter a name for the log
                NavigationLink(
                    destination: ProgressView(drivingLog: DrivingLog(name: "Alex")),
                    label: {
                        Text("Start New Log")
                            .modifier(ButtonModifier())
                    })
                
                // TODO: take user to a new screen, where user will pick from saved logs
                NavigationLink(
                    destination: ProgressView(drivingLog: selectedLog ?? DrivingLog()),
                    isActive: $userDidSelectLog,
                    label: {
                        Button("Load Previous Log") {
                            selectedLog = getDrivingLogFromUser()
                            userDidSelectLog.toggle()
                        }
                        .modifier(ButtonModifier())
                    })
                    .padding()
            }
            .navigationTitle("Home Page")
        }
    }
    
    func getDrivingLogFromUser() -> DrivingLog {
        // for now, load previous log
        // TODO: have user select log from list of profiles
        logsManager.loadLogsFromUserDefaults()
        let logsList = logsManager.listOfLogs
        
        guard let lastLog = logsList.last else {
            print("no logs exist - creating new log")
            return DrivingLog(name: "New Log")
        }
        
        print("Loaded previous log named \(lastLog.name)")
        return lastLog
    }
}

struct ChooseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLogView(selectedLog: MockDrivingLog())
    }
}
