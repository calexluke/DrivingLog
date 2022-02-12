//
//  Utility.swift
//  DrivingLog
//
//  Created by Alex Luke on 2/12/22.
//

import Foundation

struct Utility {
    
    static func timeString(from seconds: Double) -> String {
        let secondsInt = Int(seconds)
        return timeString(from: secondsInt)
    }
    
    static func timeString(from seconds: Int) -> String {
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        let hourString = hours > 9 ? "\(hours)" : "0\(hours)"
        let minuteString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let secondString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(hourString):\(minuteString):\(secondString)"
    }
}
