//
//  UserDefaultsManager.swift
//  DrivingLog
//
//  Created by Alex Luke on 2/5/22.
//

import Foundation


// this class handles saving and loading trip data to the UserDefaults database

struct UserDefaultsManager {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func saveLogsList(logs: [DrivingLog]) {
        do {
            let data = try encoder.encode(logs)
            UserDefaults.standard.set(data, forKey: StringConstants.listOfLogsKey)
            print("Saved logs list to user defaults")
        } catch {
            print("Error encoding driving logs list: \(error)")
        }
    }
    
    func loadLogsList() -> [DrivingLog]? {
        var logs: [DrivingLog]?
        
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: StringConstants.listOfLogsKey) {
            do {
                logs = try decoder.decode([DrivingLog].self, from: data)
                if logs != nil {
                    print("Successfully loaded logs list from user defaults")
                }
            } catch {
                print("Error decoding driving log: \(error)")
            }
        }
        // will return nil if decode failed
        return logs
    }
}
