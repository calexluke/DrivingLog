//
//  ChooseLogView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ChooseLogView: View {
    
    @ObservedObject var logsManager = DrivingLogsManager.sharedInstance
    @State var selectedLog = DrivingLog(name: "default")
    @State var deleteProfileAlertIsPresented = false
    
    var body: some View {
        VStack {
            
            // for debug
            HStack {
                Text("Selected Log: ")
                Text(selectedLog.name)
            }
            
            Form {
                Picker("Select a profile", selection: $selectedLog) {
                    ForEach(logsManager.listOfLogs, id: \.self) { log in
                        Text(log.name)
                    }
                }
                .pickerStyle(InlinePickerStyle())
            }
            
            Spacer()
            
            // navigate to ProgressView with selected log
            NavigationLink(
                destination: ProgressView(drivingLog: selectedLog),
                label: {
                    Text("Load Selected Profile")
                        .modifier(ButtonModifier())
                })
                .padding(.bottom)
            
            Button("Delete Selected Profile") {
                deleteProfileAlertIsPresented.toggle()
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
            .alert(isPresented: $deleteProfileAlertIsPresented) {
                deleteProfileAlert()
            }
            
        }
        .navigationTitle("Select a saved profile")
        .onAppear {
            if let lastLog = logsManager.listOfLogs.last {
                selectedLog = lastLog
            }
            
            // for debug only, add fake profiles to the list
            if !logsManager.containsLog(name: "Test1") &&
                !logsManager.containsLog(name: "Test2") {
                logsManager.listOfLogs.append(DrivingLog(name: "Test1"))
                logsManager.listOfLogs.append(DrivingLog(name: "Test2"))
            }
        }
    }
    
    func deleteProfileAlert() -> Alert {
        return Alert(
            title: Text(StringConstants.areYouSureTitle),
            message: Text(StringConstants.deletProfileAlertMessage),
            primaryButton: .destructive(Text("OK")) {
                deleteSelectedProfile()
            },
            secondaryButton: .cancel()
        )
    }
    
    func deleteSelectedProfile() {
        logsManager.deleteLog(id: selectedLog.id)
        if let lastLog = logsManager.listOfLogs.last {
            selectedLog = lastLog
        }
    }
}

struct ChooseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLogView(selectedLog: MockDrivingLog())
    }
}
