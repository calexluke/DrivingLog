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
    @ObservedObject var mapViewModel = MapViewModel()

    var drivingLog: DrivingLog
    let logsManager = DrivingLogsManager.sharedInstance
    let pdfManager = PDFManager()
    let startTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack {

            //View of the map, should take up about a third of the screen
            MapView(viewModel: mapViewModel)
              .ignoresSafeArea(edges: .top)
              .frame(height: 300)

            //Regular view starts here, code should probably be modified accordingly as the map may throw things off
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
            .padding(.bottom)
        }
        .onReceive(timer) { time in
            // called when timer ticks up
            // TODO: Decide how often to store a coordinate
//            if timeCounter % 10 == 0 {
//                if timeCounter != 0 {
//                    mapViewModel.updateLocation()
//                }
//                //map.updateLocation(route: route)
//            }
            mapViewModel.updateLocation()
            let now = Date()
            timeCounter = Int(now.timeIntervalSince(startTime))
        }
        .onAppear {
            // prevent phone from going into sleep mode during trip
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // re-enable sleep mode
            UIApplication.shared.isIdleTimerDisabled = false
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
        var newTrip = Trip(startTime: startTime, endTime: Date(), supervisorName: supervisorName)
        newTrip.route = mapViewModel.route
        drivingLog.addNewTrip(newTrip)
        logsManager.updateAndSaveLogsList(with: drivingLog)
        // write to pdf in BG thread
        DispatchQueue.global(qos: .default).async {
            pdfManager.writeTripDataToPDF(for: drivingLog.trips, id: drivingLog.id)
        }
    }

    func dismissView() {
        self.presentationMode.wrappedValue.dismiss()
    }

    func getTimeString() -> String {
        return Utility.hoursMinutesSecondsString(from: timeCounter)
    }

    func cancelAlert() -> Alert {
        return Alert(
            title: Text(StringConstants.areYouSureTitle),
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
