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
    
    //sets the current log to the one that was selected
    init(selectedLog: DrivingLog) {
        self.selectedLog = selectedLog
        UITableView.appearance().backgroundColor = .clear
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            
            //creates a form which all the saved profiles are listed under
            Form {
                Picker("Select a profile", selection: $selectedLog) {
                    ForEach(logsManager.listOfLogs, id: \.self) { log in
                        Text(log.name)
                            .foregroundColor(Theme.primaryTextColor)
                    }
                }
                .listRowBackground(Theme.appBackgroundColor)
                .pickerStyle(InlinePickerStyle())
                
            }
            .background(Theme.secondaryBackgroundColor)
            
            Spacer()
            
            // navigate to ProgressView with selected log
            NavigationLink(
                destination: ProgressView(drivingLog: selectedLog),
                label: {
                    Text("Load Selected Profile")
                        .modifier(ButtonModifier())
                })
                .padding([.bottom, .top])
            
            //deletes a profile if this button is clicked
            Button("Delete Selected Profile") {
                deleteProfileAlertIsPresented.toggle()
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
            //final alert before deleting profile
            .alert(isPresented: $deleteProfileAlertIsPresented) {
                deleteProfileAlert()
            }
            
        }
        .background(
            Theme.appBackgroundColor
                .ignoresSafeArea()
        )
        //text on top of screen
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
    
    /*This function provides the popup before the profile is deleted
    to confirm the user wants to delete the profile.*/
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
    
    /*This function removes the selected profile from the 
    remaining saved profiles.*/
    func deleteSelectedProfile() {
        logsManager.deleteLog(id: selectedLog.id)
        if let lastLog = logsManager.listOfLogs.last {
            selectedLog = lastLog
        }
    }
}

/*This struct creates the view displayed to the user*/
struct ChooseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLogView(selectedLog: MockDrivingLog())
    }
}
