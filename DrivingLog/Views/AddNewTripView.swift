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
            Text("Add new trip")
                .font(.title)
                .padding()
            
            
            HStack(alignment: .center) {
                Text("Supervisor: ")
                    .font(.title)
                TextField(StringConstants.supervisorHint, text: $supervisorName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            DatePicker(selection: $startTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("Start Time:")
            }
            .padding(.leading)
            .padding(.trailing)
            
            DatePicker(selection: $endTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute]) {
                Text("End Time:")
            }
            .padding([.leading, .trailing, .bottom])
            
            Spacer()
            
            Button("Save") {
                saveNewTrip()
            }
            .modifier(ButtonModifier())
            .alert(isPresented: $dateError) {
                Alert(
                    title: Text("Oops!"),
                    message: Text("End time can't be earlier than start time!"),
                    dismissButton: .default(Text("OK"))
                    )
            }
            
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .modifier(ButtonModifier())
        }
    }
    
    func saveNewTrip() {
        guard endTime > startTime else {
            dateError = true
            return
        }
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

struct AddNewTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTripView(drivingLog: MockDrivingLog())
    }
}
