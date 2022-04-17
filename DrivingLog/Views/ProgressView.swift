//
//  ProgressView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ProgressView: View {
    @State var newTripSheetIsPresented = false
    @State var sharingPDF = false
    @ObservedObject var drivingLog: DrivingLog
    let pdfManager = PDFManager()
    
    var body: some View {
        ZStack {
            //Makes the background go past the safe area
            Theme.appBackgroundColor
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                //Title above the progress bars
                Text("Progress for \(drivingLog.name)")
                    .font(.title)
                    .bold()
                    .foregroundColor(Theme.primaryTextColor)
                    .padding(.bottom)
                
                ProgressInfoSection()
                
                Spacer()
                
                //buttons to either view saved trips or start a new trip
                NavigationLink(
                    destination: TripListView(drivingLog: drivingLog),
                    label: {
                        Text("View Saved Trips")
                            .modifier(ButtonModifier())
                    })
                    .padding()
                
                Button("Start New Trip") {
                    newTripSheetIsPresented.toggle()
                }
                .modifier(ButtonModifier())
                .padding(.bottom)

    //            // for debug and demo
    //            Button("Share Mock data pdf") {
    //                let mockLog = MockDrivingLog()
    //                pdfManager.writeTripDataToPDF(for: mockLog.trips, id: mockLog.id)
    //                if let pdfURL = pdfManager.getDocumentURL(for: mockLog.id) {
    //                    actionSheet(itemToShare: pdfURL)
    //                }
    //            }
    //            .modifier(ButtonModifier())
    //            .padding(.bottom)
    //            .ignoresSafeArea()
            }
        }
        .sheet(isPresented: $sharingPDF, onDismiss: {
            print("share pdf sheet dismissed")
        }, content: {
            ActivityView(activityItems: [pdfManager.getDocumentURL(for: drivingLog.id) ?? "Error retrieveing PDF document"])
        })
        .toolbar {
            //icon that allows for user to share the pdf
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Share pdf in actionsheet button tapped")
                    sharingPDF = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $newTripSheetIsPresented, content: {
            TripInProgressView(drivingLog: drivingLog)
        })
        //title of screen
        .navigationTitle("Overall Progress")
    }
}

/*This struct makes a new progress view.*/
struct ProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressView(drivingLog: MockDrivingLog())
    }
}

// MARK: internal views

extension ProgressView {
    /*This view generates the progress bars and the text that 
    goes with them.*/
    func ProgressInfoSection() -> some View {
        VStack {
            //Total driving time bar
            Text("\(totalDrivingTimeString()) out of 50 total driving hours")
                .foregroundColor(Theme.primaryTextColor)
                .padding([.leading, .trailing])
            
            ProgressBarStack(icon: Image(systemName: "sun.max"),
                             progress: CGFloat(drivingLog.totalDrivingTimeProportion()),
                             color1: Theme.dayColor1,
                             color2: Theme.dayColor2)
                .padding([.leading, .trailing, .bottom])
            //Time for night driving bar
            Text("\(nightDrivingTimeString()) out of 10 night driving hours")
                .foregroundColor(Theme.primaryTextColor)
                .padding([.leading, .trailing])
            
            ProgressBarStack(icon: Image(systemName: "moon.stars"),
                             progress: CGFloat(drivingLog.nightDrivingTimeProportion()),
                             color1: Theme.nightColor1,
                             color2: Theme.nightColor2)
                .padding([.leading, .trailing, .bottom])
        }
    }
    
    /*This function allows the progress bar to appear correctly to the user.*/
    func ProgressBarStack(icon: Image, progress: CGFloat, color1: Color, color2: Color) -> some View {
        HStack {
            icon
                .foregroundColor(color2)
            ProgressBar(width: 300, height: 40, percent: progress, color1: color1, color2: color2)
                .animation(.spring(), value: progress)
        }
    }
}

// MARK: helper methods

extension ProgressView {
    /*This function returns the string for total driving time.*/
    func totalDrivingTimeString() -> String {
        return Utility.hoursMinutesString(from: drivingLog.getTotalDrivingTime())
    }
    /*This function returns the string for night driving time.*/
    func nightDrivingTimeString() -> String {
        return Utility.hoursMinutesString(from: drivingLog.getNightDrivingTime())
    }
}
