//
// PDFManager.swift
// PDFManager
//
// Created by Thomas Hohnholt on 2/8/22
//
import SwiftUI
import PDFKit
import Foundation

class PDFManager {
    
    let blankPDFFileName = "IndianaFormPDF"
    let blankPDF: PDFDocument?
    
    let page1Rows = 31
    let page2Rows = 23
    let columnsPerRow = 6
    let page1Column1StartingTextfield = "Text4.0.0"
    let page1Column2StartingTextfield = "Text4.3.0"
    let page2Column1StartingTextfield = "Text5.0.0"
    let page2Column2StartingTextfield = "Text5.3.0"
    
    var page1column2TripIndex: Int {
        return page1Rows
    }
    
    var page2column1TripIndex: Int {
        return page1Rows * 2
    }
    
    var page2column2TripIndex: Int {
        return (page1Rows * 2) + page2Rows
    }

    init() {
        if let pathToBlankForm = Bundle.main.path(forResource: "IndianaFormPDF", ofType: "pdf") {
            // create PDFKit PDF object
            blankPDF = PDFDocument(url: URL(fileURLWithPath: pathToBlankForm))
        } else {
            blankPDF = nil
        }
    }

    // MARK: basic file I/O functions
    
    func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }

    private func append(to pathToDocsDir: String, with fileName: String) -> String? {
        if var pathURL = URL(string: pathToDocsDir) {
            pathURL.appendPathComponent(fileName)

            return pathURL.absoluteString
        }
        return nil
    }

    func getFileURLFromDocsDir(fileName: String) -> URL? {
        guard let filePath = self.append(to: self.documentDirectory(),
                                         with: fileName) else {
            return nil
        }

        let url = URL(fileURLWithPath: filePath)
        return url
    }
    
    func getDocumentURL(for tripLogID: UUID) -> URL? {
        let fileName = getFileName(from: tripLogID)
        return getFileURLFromDocsDir(fileName: fileName)
    }
    
    func getFileName(from id: UUID) -> String {
        return "TripLog\(id).pdf"
    }

    // MARK: write trip data to PDF!
    
    // write trip log data to state of indiana form
    func writeTripDataToPDF(for tripList: [Trip], id: UUID) {
        
        guard let pdfDocument = blankPDF else {
            print("Error finding blank PDF form!")
            return
        }
        
        let page1 = pdfDocument.page(at: 0)
        let page2 = pdfDocument.page(at: 1)
        let page1Annotations = page1?.annotations
        let page2Annotations = page2?.annotations
        
        // get all the annotations that represent form fields
        guard var page1FormFields = page1Annotations?.filter({ $0.fieldName != nil }),
              var page2FormFields = page2Annotations?.filter({ $0.fieldName != nil }) else {
                  print("Error finding text field annotations in PDF!")
                  return
              }
        
        // get the index of the first form field in each column
        guard let p1column1FieldIndex = getTextFieldIndex(for: page1Column1StartingTextfield, in: page1FormFields),
              let p1column2FieldIndex = getTextFieldIndex(for: page1Column2StartingTextfield, in: page1FormFields),
              let p2column1FieldIndex = getTextFieldIndex(for: page2Column1StartingTextfield, in: page2FormFields),
              let p2column2FieldIndex = getTextFieldIndex(for: page2Column2StartingTextfield, in: page2FormFields) else {
                  print("Error finding index of form fields!")
                  return
              }
        
        // make sure doc is clear before writing
        for field in page1FormFields {
            field.widgetStringValue = ""
        }
        
        for field in page2FormFields {
            field.widgetStringValue = ""
        }
        
        // slice trip list into sub-arrays for each column of the PDF depending on number of trips
        switch tripList.count {
            case 0...page1Rows:
                // one column only
                let page1Column1Trips = tripList[0..<tripList.endIndex]
                writeTripDataToPDFTextFields(trips: page1Column1Trips, textfieldStartIndex: p1column1FieldIndex, fieldsArray: &page1FormFields)
                
            case (page1Rows + 1)...(page1Rows * 2):
                // one page, two columns
                let page1Column1Trips = tripList[0..<page1column2TripIndex]
                let page1Column2Trips = tripList[page1column2TripIndex..<tripList.endIndex]
                writeTripDataToPDFTextFields(trips: page1Column1Trips, textfieldStartIndex: p1column1FieldIndex, fieldsArray: &page1FormFields)
                writeTripDataToPDFTextFields(trips: page1Column2Trips, textfieldStartIndex: p1column2FieldIndex, fieldsArray: &page1FormFields)
                
            case (page1Rows * 2) + 1...(page1Rows * 2) + page2Rows:
                // both columns on first page, 1 column on second
                let page1Column1Trips = tripList[0..<page1column2TripIndex]
                let page1Column2Trips = tripList[page1column2TripIndex..<page2column1TripIndex]
                let page2Column1Trips = tripList[page2column1TripIndex..<tripList.endIndex]
                writeTripDataToPDFTextFields(trips: page1Column1Trips, textfieldStartIndex: p1column1FieldIndex, fieldsArray: &page1FormFields)
                writeTripDataToPDFTextFields(trips: page1Column2Trips, textfieldStartIndex: p1column2FieldIndex, fieldsArray: &page1FormFields)
                writeTripDataToPDFTextFields(trips: page2Column1Trips, textfieldStartIndex: p2column1FieldIndex, fieldsArray: &page2FormFields)
                
            case (page1Rows * 2) + page2Rows + 1...(page1Rows * 2) + (page2Rows * 2):
                // all four columns on both pages
                let page1Column1Trips = tripList[0..<page1column2TripIndex]
                let page1Column2Trips = tripList[page1column2TripIndex..<page2column1TripIndex]
                let page2Column1Trips = tripList[page2column1TripIndex..<page2column2TripIndex]
                let page2Column2Trips = tripList[page2column2TripIndex..<tripList.endIndex]
                writeTripDataToPDFTextFields(trips: page1Column1Trips, textfieldStartIndex: p1column1FieldIndex, fieldsArray: &page1FormFields)
                writeTripDataToPDFTextFields(trips: page1Column2Trips, textfieldStartIndex: p1column2FieldIndex, fieldsArray: &page1FormFields)
                writeTripDataToPDFTextFields(trips: page2Column1Trips, textfieldStartIndex: p2column1FieldIndex, fieldsArray: &page2FormFields)
                writeTripDataToPDFTextFields(trips: page2Column2Trips, textfieldStartIndex: p2column2FieldIndex, fieldsArray: &page2FormFields)
                
            default:
                // TODO: start second pdf doc when there are this many trips.
                // for now just truncate the list to fit on one document
                let page1Column1Trips = tripList[0..<page1column2TripIndex]
                let page1Column2Trips = tripList[page1column2TripIndex..<page2column1TripIndex]
                let page2Column1Trips = tripList[page2column1TripIndex..<page2column2TripIndex]
                let page2Column2Trips = tripList[page2column2TripIndex..<(page1Rows * 2) + (page2Rows * 2)]
                writeTripDataToPDFTextFields(trips: page1Column1Trips, textfieldStartIndex: p1column1FieldIndex, fieldsArray: &page1FormFields)
                writeTripDataToPDFTextFields(trips: page1Column2Trips, textfieldStartIndex: p1column2FieldIndex, fieldsArray: &page1FormFields)
                writeTripDataToPDFTextFields(trips: page2Column1Trips, textfieldStartIndex: p2column1FieldIndex, fieldsArray: &page2FormFields)
                writeTripDataToPDFTextFields(trips: page2Column2Trips, textfieldStartIndex: p2column2FieldIndex, fieldsArray: &page2FormFields)
        }
                
        // save to docs directory
        let fileName = getFileName(from: id)
        if let urlToSave = getFileURLFromDocsDir(fileName: fileName) {
            pdfDocument.write(to: urlToSave)
        } else {
            print("Error saving pdf to docs directory")
        }
    }
    
    func getTextFieldIndex(for annotation: String, in fieldList: [PDFAnnotation]) -> Int? {
        let index = fieldList.firstIndex(where: { $0.fieldName == annotation })
        return index
    }
    
    func writeTripDataToPDFTextFields(trips: ArraySlice<Trip>, textfieldStartIndex: Int, fieldsArray: inout [PDFAnnotation]) {
        let formatter = DateFormatter()
        formatter.dateFormat = StringConstants.pdfDateFormat
        
        var fieldIndex = textfieldStartIndex
        for trip in trips {
            fieldsArray[fieldIndex + 0].widgetStringValue = formatter.string(from: trip.startTime)
            fieldsArray[fieldIndex + 1].widgetStringValue = Utility.hoursMinutesString(from: trip.dayTimeDuration)
            fieldsArray[fieldIndex + 2].widgetStringValue = Utility.hoursMinutesString(from: trip.nightTimeDuration)
            // skip to next row
            fieldIndex += columnsPerRow
        }
    }
}


