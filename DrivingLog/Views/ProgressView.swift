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
        
        VStack {
            Spacer()
            Text("Progress for \(drivingLog.name)")
                .font(.title)
            Text("Total driving time: \(totalDrivingTimeString())")
                .font(.title)
            Text("Night Driving time: \(nightDrivingTimeString())")
                .font(.title)
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
            
            // for debug and demo
            Button("Share Mock data pdf") {
                let mockLog = MockDrivingLog()
                pdfManager.writeTripDataToPDF(for: mockLog.trips, id: mockLog.id)
                if let pdfURL = pdfManager.getDocumentURL(for: mockLog.id) {
                    actionSheet(itemToShare: pdfURL)
                }
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
            .ignoresSafeArea()
        }
        .sheet(isPresented: $newTripSheetIsPresented, content: {
            TripInProgressView(drivingLog: drivingLog)
        })
        .navigationTitle("Overall Progress")
    }
    
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

struct ProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressView(drivingLog: MockDrivingLog())
    }
}
