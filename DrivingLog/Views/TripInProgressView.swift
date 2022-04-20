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
    let cloudManager = CloudManager()
    let startTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                //View of the map, should take up about a third of the screen
                MapView(viewModel: mapViewModel)
                  .ignoresSafeArea(edges: .top)
                VStack {
                    HStack {
                        Spacer()
                        // Button to recenter map on user
                        Button(action: {
                            mapViewModel.autoCenteringEnabled = true
                            mapViewModel.centerMapOnUser()
                        }, label:  {
                            Image(systemName: "scope")
                                .foregroundColor(Theme.accentColor)
                                .font(.system(size: 30))
                                .shadow(color: .gray, radius: 2, x: 3, y: 3)
                                .padding()
                        })
                    }
                    Spacer()
                }
            }

            Spacer()

            Text("\(getTimeString())")
                .foregroundColor(Theme.primaryTextColor)
                .font(.largeTitle)
                .padding()

            HStack(alignment: .center) {
                //Creates the field and label for the supervisor
                Text("Supervisor: ")
                    .foregroundColor(Theme.primaryTextColor)
                    .font(.title)
                TextField(StringConstants.supervisorHint, text: $supervisorName)
                    .modifier(TextFieldModifer())
            }
            .padding()

            Button(action: {
                endTrip()
            }, label: {
                Text("End Trip")
                    .modifier(ButtonModifier())
                    .padding(.bottom)
            })
            //presents an alert to the supervisor that the trip was completed
            .alert(isPresented: $supervistorAlertIsPresented) {
                supervisorAlert()
            }

            Button(action: {
                cancelTrip()
            }, label: {
                Text("Cancel Trip")
                    .modifier(ButtonModifier())
            })
            //pops up an alert asking if the user really wants to quit the trip
            .alert(isPresented: $cancelAlertIsPresented) {
                cancelAlert()
            }
            .padding(.bottom)
        }
        .background(
            Theme.appBackgroundColor
                .ignoresSafeArea()
        )
        .onReceive(timer) { time in
            // called when timer ticks up
            // TODO: Decide how often to store a coordinate
//            if timeCounter % 10 == 0 {
//                if timeCounter != 0 {
//                    mapViewModel.updateLocation()
//                }
//                //map.updateLocation(route: route)
//            }
            //updates the coordinates throughout the trip
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

    /*This function pops up the alert to confirm if the user
    wants to cancel the trip or not.*/
    func cancelTrip() {
        cancelAlertIsPresented.toggle()
    }

    /*This function adds the trip to the driving log and 
    goes to the next view.*/
    func endTrip() {
        //Checks if a supervisor was entered
        guard supervisorName != "" else {
            supervistorAlertIsPresented.toggle()
            return
        }
        addNewTrip()
        dismissView()
    }

    /*This function adds the trip and its elements like the map view and times
    to the log and updates the PDF with that log.*/
    func addNewTrip() {
        var newTrip = Trip(startTime: startTime,
                           endTime: Date(),
                           supervisorName: supervisorName,
                           logID: drivingLog.id)
        newTrip.locations = mapViewModel.locations
        newTrip.hasLocationData = true
        drivingLog.addNewTrip(newTrip)
        logsManager.updateAndSaveLogsList(with: drivingLog)
        // write to pdf in BG thread
        DispatchQueue.global(qos: .default).async {
            cloudManager.saveTrip(newTrip)
            pdfManager.writeTripDataToPDF(for: drivingLog.trips, id: drivingLog.id)
        }
    }

    /*This function takes the user to a different screen*/
    func dismissView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    /*This function gets the time which is returned as a string.*/
    func getTimeString() -> String {
        return Utility.hoursMinutesSecondsString(from: timeCounter)
    }

    /*This function generates the popup for cancelling a trip.*/
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

    /*This function alerts the supervisor that a trip was completed.*/
    func supervisorAlert() -> Alert {
        return Alert(
            title: Text(""),
            message: Text(StringConstants.supervisorAlertMessage),
            dismissButton: .default(Text("OK"))
        )
    }
    

}

/*This struct generates the trip in progress view.*/
struct TripInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TripInProgressView(drivingLog: MockDrivingLog())
    }
}
