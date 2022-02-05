//
//  DrivingLogsManager.swift
//  DrivingLog
//
//  Created by Alex Luke on 2/5/22.
//

import Foundation

// this class manages the list of driving logs for multiple users
class DrivingLogsManager {
    
    static let sharedInstance = DrivingLogsManager()
    let defaultsManager = UserDefaultsManager()
    
    var listOfLogs = [DrivingLog]()
    
    func addNewLog(_ log: DrivingLog) {
        listOfLogs.append(log)
        defaultsManager.saveLogsList(logs: listOfLogs)
    }
    
    func loadLogsFromUserDefaults() {
        guard let loadedLogs = defaultsManager.loadLogsList() else {
            return
        }
        
        listOfLogs = loadedLogs
    }
    
    func updateAndSaveLogsList(with log: DrivingLog) {
        // if log already exists, update it.
        // else, add new log
        var logExists = false
        for (i, savedLog) in listOfLogs.enumerated() {
            if savedLog.id == log.id {
                logExists = true
                listOfLogs[i] = log
                print("Updating existing log named \(savedLog.name)")
            }
        }
        
        if !logExists {
            listOfLogs.append(log)
            print("Adding new log to list")
        }
        
        defaultsManager.saveLogsList(logs: listOfLogs)
    }
}
