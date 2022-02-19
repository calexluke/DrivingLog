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
    
    var body: some View {
        
        VStack {
            Spacer()
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
            
            Button("Start New Trip") {
                newTripSheetIsPresented.toggle()
            }
            .modifier(ButtonModifier())
            .padding()
            
            Button("Share document") {
                shareDrivingDataTextFile()
            }
            .modifier(ButtonModifier())
            
            Button("Write data to PDF") {
                shareDrivingDataPDF()
            }
            .modifier(ButtonModifier())
            .padding()
        }
        .sheet(isPresented: $newTripSheetIsPresented, content: {
            TripInProgressView(drivingLog: drivingLog)
        })
        .navigationTitle("Overall Progress")
    }
    
    func totalDrivingTimeString() -> String {
        return Utility.timeString(from: drivingLog.getTotalDrivingTime())
    }
    
    func nightDrivingTimeString() -> String {
        return Utility.timeString(from: drivingLog.getNightDrivingTime())
    }
    
    func shareDrivingDataTextFile() {
        let manager = PDFManager()
        let filename = "DrivingData.txt"
        manager.overWriteFileInDocsDir(filename, with: "Trip Data: \n\n")
        
        for trip in drivingLog.trips {
            let multiLineMessage = """
            Start Time: \(trip.startTime)
            End Time: \(trip.endTime)
            Supervisor: \(trip.supervisorName)
            
            """
            manager.appendToFileInDocsDir(filename, with: multiLineMessage + "\n")
        }
        
        if let documentURL = manager.getFileURLFromDocsDir(fileName: filename) {
            actionSheet(itemToShare: documentURL)
        }
    }
    
    func shareDrivingDataPDF() {
        if let pdfURL = PDFManager().getDocumentURL(for: drivingLog) {
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
