//
//  ChooseLogView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ChooseLogView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let logsManager = DrivingLogsManager.sharedInstance
    @State var selectedLog = DrivingLog(name: "default")
    @State var deleteProfileAlertIsPresented = false
    @State var navigateToProgressView = false
    @State var logsList = [DrivingLog]()
    
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
                    ForEach(logsList, id: \.self) { log in
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
            NavigationLink(destination: ProgressView(drivingLog: selectedLog),
                           isActive: $navigateToProgressView, label: {
                Button("Load Selected Profile") {
                    writeSelectedLogToPDF()
                    navigateToProgressView = true
                }
                .modifier(ButtonModifier())
                .padding([.bottom, .top])
            })
            
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
            if logsList.isEmpty {
                logsList = logsManager.listOfLogs
            }
            
            if selectedLog.name == "default" {
                if let lastLog = logsList.last {
                    selectedLog = lastLog
                }
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
        logsList = logsManager.listOfLogs
        if let lastLog = logsList.last {
            selectedLog = lastLog
        } else {
            // go back to home view if no logs are left in list
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func writeSelectedLogToPDF() {
        DispatchQueue.global(qos: .default).async {
            PDFManager().writeTripDataToPDF(for: selectedLog.trips, id: selectedLog.id)
        }
    }
}

/*This struct creates the view displayed to the user*/
struct ChooseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLogView(selectedLog: MockDrivingLog())
    }
}
