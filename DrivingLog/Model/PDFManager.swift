//
// PDFManager.swift
// PDFManager
//
// Created by Thomas Hohnholt on 2/8/22
//
import SwiftUI
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
        /*:
        do {
            let savedString = try String(contentsOfFile: filePath)
            print(savedString)
        } catch {
            print("Error reading saved file")
        }
        */
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
        //Writing stuff to text files deleted, unnecessary, but can be added back
        /*:
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        */
        print("Save successful")
    }



    func clearFileInDocsDir(_ fileName: String) {
        overWriteFileInDocsDir(fileName, with: "")
    }

    func overWriteFileInDocsDir(_ fileName: String, with text: String) {
        guard let filePath = getFilePathFromDocsDir(fileName: fileName) else {
            return
        }
        /*:
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error writing to document", error)
            return
        }
        */
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



}


//THIS IS TEST STUFF, NEEDS TO BE INTEGRATED!!
//Writing to the pdf
import UIKit
import PDFKit

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
