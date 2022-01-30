//
//  Trip.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation

struct Trip: Identifiable {
    let id = UUID()
    var startTime: Date
    var endTime: Date
    var supervisorName: String
    
    // array of GPS data?
    // var route:
    
    var totaldDurationInSeconds: Double {
        return endTime.timeIntervalSince(startTime)
    }
    
    var dayTimeDuration: Double {
        return totaldDurationInSeconds * getDayTimeRatio()
    }
    
    var nightTimeDuration: Double {
        return totaldDurationInSeconds * (1 - getDayTimeRatio())
    }
    
    func getDayTimeRatio() -> Double {
        //TODO: use start time and end time to figure out what percentage of the trip was in day time
        return 0.5
    }
    
    // convert time in seconds to a string for display
    func getTimeString(timeInSeconds: Double) -> String {
        return "0:00"
    }
}
