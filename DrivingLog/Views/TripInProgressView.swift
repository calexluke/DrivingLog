//
//  TripInProgressView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct TripInProgressView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var timeCounter = 0
    @State var supervisorName = ""
    @State var supervistorAlertIsPresented = false
    @State var cancelAlertIsPresented = false
    
    var drivingLog: DrivingLog
    let startTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
        
            Spacer()
            
            Text("Current trip time: ")
            Text("\(getTimeString())")
                .font(.largeTitle)
                .padding()
            Spacer()
            
            HStack(alignment: .center) {
                Text("Supervisor: ")
                    .font(.title)
                TextField(StringConstants.supervisorHint, text: $supervisorName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            Button("End Trip") {
                endTrip()
            }
            .modifier(ButtonModifier())
            .alert(isPresented: $supervistorAlertIsPresented) {
                supervisorAlert()
            }
            
            Button("Cancel Trip") {
                cancelTrip()
            }
            .modifier(ButtonModifier())
            .alert(isPresented: $cancelAlertIsPresented) {
                cancelAlert()
            }
        }
        .onReceive(timer) { time in
            let now = Date()
            timeCounter = Int(now.timeIntervalSince(startTime))
        }
    }
    
    func cancelTrip() {
        cancelAlertIsPresented.toggle()
    }
    
    func endTrip() {
        guard supervisorName != "" else {
            supervistorAlertIsPresented.toggle()
            return
        }
        addNewTrip()
        dismissView()
    }
    
    func addNewTrip() {
        let newTrip = Trip(startTime: startTime, endTime: Date(), supervisorName: supervisorName)
        drivingLog.addNewTrip(newTrip)
    }
    
    func dismissView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func getTimeString() -> String {
        let hours = (timeCounter % 86400) / 3600
        let minutes = (timeCounter % 3600) / 60
        let seconds = (timeCounter % 3600) % 60
        
        let hourString = hours > 9 ? "\(hours)" : "0\(hours)"
        let minuteString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let secondString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(hourString):\(minuteString):\(secondString)"
    }
    
    func cancelAlert() -> Alert {
        return Alert(
            title: Text(StringConstants.cancelAlertTitle),
            message: Text(StringConstants.cancelAlertMessage),
            primaryButton: .destructive(Text("OK")) {
                dismissView()
            },
            secondaryButton: .cancel()
        )
    }
    
    func supervisorAlert() -> Alert {
        return Alert(
            title: Text(""),
            message: Text(StringConstants.supervisorAlertMessage),
            dismissButton: .default(Text("OK"))
        )
    }
        
}

struct TripInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TripInProgressView(drivingLog: MockDrivingLog())
    }
}
