//
//  TripDetailView.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//
import SwiftUI
import UIKit
import PDFKit

struct TripDetailView: View {
    let trip: Trip
    var body: some View {
        VStack {
            Text("Start Time: \(trip.startTime)")
                .font(.title3)
                .padding()
            Text("End Time: \(trip.endTime)")
                .font(.title3)
                .padding()
            Text("Supervisor: \(trip.supervisorName)")
                .font(.title3)
                .padding()
            Text("Other data?")

            Button("Write data to PDF") {
                writeDataToPDF()
            }

        }
        .navigationTitle("Trip detail")
    }
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailView(trip: Trip(startTime: Date(), endTime: Date() + 60, supervisorName: "Alex"))
    }
}

//THIS IS TEST STUFF, NEEDS TO BE INTEGRATED!!
//Writing to the pdf
func writeDataToPDF() {
  let trip: Trip
  //PDF URL needs to be modified a hair, this is just some code
  let pdfURL = ...
  let document = PDFDocument(url: pdfURL!)
  let page1 = document!.page(at: 0)

  let field = page1?.annotations.filter({ $0.fieldName! == "Date" })
  //Start time needs to be in mm/dd/yyyy format
  field?[0].widgetStringValue = trip.startTime

  //Once when check box is implemented, run an if statement. This is just a skeleton for what is to come
  //We also need to do some calculations for minutes, this once again is just a start
  var night = true
  if night == true{
    let field = page1?.annotations.filter({ $0.fieldName! == "Night" })
    //Start time needs to be in mm/dd/yyyy format
    //Test values
    field?[0].widgetStringValue = "1h55m"
  }
  else{
    let field = page1?.annotations.filter({ $0.fieldName! == "Day" })
    //Start time needs to be in mm/dd/yyyy format
    //Test values
    field?[0].widgetStringValue = "45m"
  }

  //saveURL also needs to be modified a hair, this is just some code
  let saveURL = ...
  document!.write(to: saveURL)
}
