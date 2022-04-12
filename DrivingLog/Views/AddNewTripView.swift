//
//  AddNewTripView.swift
//  DrivingLog
//
//  Created by Alex Luke on 3/19/22.
//

import SwiftUI

struct AddNewTripView: View {
    
    let logsManager = DrivingLogsManager.sharedInstance
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var drivingLog: DrivingLog
    @State var startTime = Date()
    @State var endTime = Date()
    @State var supervisorName = ""
    @State var dateError = false
    let pdfManager = PDFManager()
    
    var body: some View {
        VStack {
            
            Spacer()
            //Adding text for a new trip on the screen
            Text("Add New Trip")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title)
                .bold()
                .padding()
            
            HStack(alignment: .center) {
                //Adding supervisor label
                Text("Supervisor: ")
                    .foregroundColor(Theme.primaryTextColor)
                    .font(.title)
                //supervisor text box
                TextField(StringConstants.supervisorHint, text: $supervisorName)
                    .modifier(TextFieldModifer())
            }
            .padding()
            //date picker for start time
            DatePicker(selection: $startTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("Start Time:")
                    .foregroundColor(Theme.primaryTextColor)
            }
            .padding(.leading)
            .padding(.trailing)
            //date picker for end time
            DatePicker(selection: $endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("End Time:")
                    .foregroundColor(Theme.primaryTextColor)
            }
            .padding([.leading, .trailing, .bottom])
            
            Spacer()
            //button to save all changes on the app
            Button("Save") {
                saveNewTrip()
            }
            .modifier(ButtonModifier())
            .alert(isPresented: $dateError) {
                //error message if the end time is before the start time
                Alert(
                    title: Text("Oops!"),
                    message: Text("End time can't be earlier than start time!"),
                    dismissButton: .default(Text("OK"))
                    )
            }
            //button to cancel adding a new trip
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
        }
        .background(
            Theme.appBackgroundColor
                .ignoresSafeArea()
        )
    }
    
    /*This function is called after the correct fields are filled
    out and the save button is clicked. This saves the trip to the
    log of trips for the current user.*/
    func saveNewTrip() {
        //checks for date errors
        guard endTime > startTime else {
            dateError = true
            return
        }
        //adds new trip to list
        let newTrip = Trip(startTime: startTime, endTime: endTime, supervisorName: supervisorName)
        drivingLog.addNewTrip(newTrip)
        logsManager.updateAndSaveLogsList(with: drivingLog)
        // write to pdf in BG thread
        DispatchQueue.global(qos: .default).async {
            pdfManager.writeTripDataToPDF(for: drivingLog.trips, id: drivingLog.id)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

/*This struct adds a preview for the trip detail view.*/
struct AddNewTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTripView(drivingLog: MockDrivingLog())
    }
}
