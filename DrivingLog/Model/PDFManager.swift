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

    //  a blank Indiana Driving Log would go here
    init() {

    }

    //Looking for the .documentDirectory, so we can save the pdf there
    func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }

    // Adding the path component to the file name (which the pdf will be under)
    private func append(to pathToDocsDir: String, with fileName: String) -> String? {
        if var pathURL = URL(string: pathToDocsDir) {
            pathURL.appendPathComponent(fileName)

            return pathURL.absoluteString
        }
        return nil
    }

    //Reading in our file, in this case, it would be the Indiana Driving Log
    func readFileFromDocuments(fileName: String) {
        guard let filePath = self.append(to: self.documentDirectory(),
                                         with: fileName) else {
            return
        }

        //This function is only necessary for text files, trying to convert to pdf here
        do {
            let savedString = try String(contentsOfFile: filePath)
            print(savedString)
        } catch {
            print("Error reading saved file")
        }
    }

    func getFileURLFromDocsDir(fileName: String) -> URL? {
        guard let filePath = self.append(to: self.documentDirectory(),
                                         with: fileName) else {
            return nil
        }

        let url = URL(fileURLWithPath: filePath)
        return url
    }

    func getFilePathFromDocsDir(fileName: String) -> String? {
        var path: String?
        let docsDir = documentDirectory()
        if let filePath = self.append(to: docsDir, with: fileName) {
            path = filePath
        }
        return path
    }

    // Saving the pdf to the documents directory
    func save(text: String,
              toDirectory directory: String,
              withFileName fileName: String) {
        guard let filePath = self.append(to: directory,
                                         with: fileName) else {
            return
        }
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        print("Save successful")
    }
    



    func clearFileInDocsDir(_ fileName: String) {
        overWriteFileInDocsDir(fileName, with: "")
    }

    func overWriteFileInDocsDir(_ fileName: String, with text: String) {
        guard let filePath = getFilePathFromDocsDir(fileName: fileName) else {
            return
        }
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error writing to document", error)
            return
        }
        print("Save successful")
    }

    func appendToFileInDocsDir(_ fileName: String, with text: String) {
        guard let fileURL = getFileURLFromDocsDir(fileName: fileName) else {
            print("Error getting file path URL")
            return
        }

        if let handle = try? FileHandle(forWritingTo: fileURL) {
            handle.seekToEndOfFile() // moving pointer to the end
            handle.write(text.data(using: .utf8)!) // adding content
            handle.closeFile() // closing the file
            print("Successfully appended to file \(fileName)")
        } else {
            print("Error appending to file")
        }
    }
    
    // MARK: write trip data to PDF!
    
    // write trip log data to state of indiana form and return url of the new doc
    func getDocumentURL(for tripLog: DrivingLog) -> URL? {
        let fileName = getFileName(for: tripLog)
        var documentURL: URL?
        writeTripDataToPDF(for: tripLog)
        if let url = PDFManager().getFileURLFromDocsDir(fileName: fileName) {
            documentURL = url
        }
        return documentURL
    }
    
    // for now this just fills in all fields with their internal annotation name
    // TODO: algorithm to fill in correct fields with the trip data
    func writeTripDataToPDF(for tripLog: DrivingLog) {
        // get location of the blank pdf from project directory
        if let pathToBlankForm = Bundle.main.path(forResource: "IndianaFormPDF", ofType: "pdf") {
            // create PDFKit PDF object
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: pathToBlankForm)) {
                // loop through all pages
                for i in 0...pdfDocument.pageCount - 1 {
                    let page = pdfDocument.page(at: i)
                    let annotations = page?.annotations
                    // get all the annotations that represent form fields
                    if let formFields = annotations?.filter({ $0.fieldName != nil }) {
                        // write text to each form field with the actual embedded field name
                        for field in formFields {
                            print("field name: \(field.fieldName ?? "not available")")
                            print("field widget field type: \(field.widgetFieldType)")
                            field.widgetStringValue = field.fieldName
                        }
                    }
                }
                let fileName = getFileName(for: tripLog)
                if let urlToSave = PDFManager().getFileURLFromDocsDir(fileName: fileName) {
                    pdfDocument.write(to: urlToSave)
                }
            }
        }
    }
    
    func getFileName(for tripLog: DrivingLog) -> String {
        return "TripLog\(tripLog.id).pdf"
    }
}
