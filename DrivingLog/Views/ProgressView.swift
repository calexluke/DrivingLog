//
//  ProgressView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import SwiftUI

struct ProgressView: View {
    @State var newTripSheetIsPresented = false
    
    var drivingLog: DrivingLog
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Progress Bar Here")
                .font(.title)
            Text("and other data?")
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
                shareMockDrivingData()
            }
            .modifier(ButtonModifier())
        }
        .sheet(isPresented: $newTripSheetIsPresented, content: {
            TripInProgressView(drivingLog: drivingLog)
        })
        .navigationTitle("Overall Progress")
    }
    
    func shareMockDrivingData() {
        let manager = PDFManager()
        let docsDir = manager.documentDirectory()
        let message = "Driving Data will go here"
        let filename = "DrivingData.txt"
        manager.save(text: message, toDirectory: docsDir, withFileName: filename)
        if let documentURL = manager.getFileURLFromDocsDir(fileName: filename) {
            actionSheet(itemToShare: documentURL)
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
