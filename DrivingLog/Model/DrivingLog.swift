//
//  DrivingLog.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation

class DrivingLog {
    var trips: [Trip]
    
    init() {
        // empty trip list when initialized
        trips = [Trip]()
    }
}

class MockDrivingLog: DrivingLog {
    // create log with fake data for testing
    override init() {
        super.init()
        trips = [
            Trip(startTime: Date(), endTime: Date() + 60, supervisorName: "Alex"),
            Trip(startTime: Date() + 120, endTime: Date() + 180, supervisorName: "Christian"),
            Trip(startTime: Date() + 240, endTime: Date() + 320, supervisorName: "Thomas")
        ]
    }
}
