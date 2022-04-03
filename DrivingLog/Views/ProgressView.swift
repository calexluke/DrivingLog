//
//  ProgressView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ProgressView: View {
    @State var newTripSheetIsPresented = false
    @ObservedObject var drivingLog: DrivingLog
    let pdfManager = PDFManager()
    
    var body: some View {
        ZStack {
            Theme.appBackgroundColor
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Progress for \(drivingLog.name)")
                    .font(.title)
                    .foregroundColor(Theme.primaryTextColor)
                Spacer()
                
                ProgressInfoSection()
                
                Spacer()
                
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
                
                Button("Write data to PDF") {
                    shareDrivingDataPDF()
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
        .sheet(isPresented: $newTripSheetIsPresented, content: {
            TripInProgressView(drivingLog: drivingLog)
        })
        .navigationTitle("Overall Progress")
    }
}

struct ProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressView(drivingLog: MockDrivingLog())
    }
}

// MARK: internal views

extension ProgressView {
    func ProgressInfoSection() -> some View {
        VStack {
            Text("\(totalDrivingTimeString()) out of 50 total driving hours")
                .foregroundColor(Theme.primaryTextColor)
                .padding([.leading, .trailing])
            
            ProgressBarStack(icon: Image(systemName: "sun.max"),
                             progress: CGFloat(drivingLog.totalDrivingTimeProportion()),
                             color1: Theme.dayColor1,
                             color2: Theme.dayColor2)
                .padding([.leading, .trailing, .bottom])
            
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
    func totalDrivingTimeString() -> String {
        return Utility.hoursMinutesSecondsString(from: drivingLog.getTotalDrivingTime())
    }
    
    func nightDrivingTimeString() -> String {
        return Utility.hoursMinutesSecondsString(from: drivingLog.getNightDrivingTime())
    }
    
    func shareDrivingDataPDF() {
        pdfManager.writeTripDataToPDF(for: drivingLog.trips, id: drivingLog.id)
        if let pdfURL = pdfManager.getDocumentURL(for: drivingLog.id) {
            actionSheet(itemToShare: pdfURL)
        }
    }
    
    func actionSheet(itemToShare: URL) {
        let activityVC = UIActivityViewController(activityItems: [itemToShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
