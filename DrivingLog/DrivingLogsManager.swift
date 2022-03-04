//
//  DrivingLogsManager.swift
//  DrivingLog
//
//  Created by Alex Luke on 2/5/22.
//

import Foundation

// this class manages the list of driving logs for multiple users
class DrivingLogsManager: ObservableObject {
    
    @Published var listOfLogs = [DrivingLog]()
    
    static let sharedInstance = DrivingLogsManager()
    let defaultsManager = UserDefaultsManager()
    
    private init() {
        loadLogsFromUserDefaults()
    }
    
    func addNewLog(_ log: DrivingLog) {
        listOfLogs.append(log)
        defaultsManager.saveLogsList(logs: listOfLogs)
    }
    
    func loadLogsFromUserDefaults() {
        guard let loadedLogs = defaultsManager.loadLogsList() else {
            return
        }
        
        listOfLogs = loadedLogs
        
        print("List of saved logs: ")
        for log in listOfLogs {
            print(log.name)
        }
    }
    
    func updateAndSaveLogsList(with log: DrivingLog) {
        // if log already exists, update it.
        // else, add new log
        
        if let logIndex = getIndexOfLog(id: log.id) {
            listOfLogs[logIndex] = log
            print("Updating existing log named \(log.name)")
        } else {
            listOfLogs.append(log)
            print("Adding new log to list")
        }
        defaultsManager.saveLogsList(logs: listOfLogs)
    }
    
    func deleteLog(id: UUID) {
        guard let index = getIndexOfLog(id: id) else {
            print("Cannot delete - log does not exist!")
            return
        }
        let logName = listOfLogs[index].name
        print("deleting log named \(logName)")
        listOfLogs.remove(at: index)
        defaultsManager.saveLogsList(logs: listOfLogs)
    }
    
    func getIndexOfLog(id: UUID) -> Int? {
        var index: Int?
        if let i = listOfLogs.firstIndex(where: { $0.id == id }) {
            index = i
        }
        return index
    }
    
    func containsLog(name: String) -> Bool {
        for log in listOfLogs {
            if log.name == name {
                return true
            }
        }
        return false
    }
}
