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
    
    
    
}
