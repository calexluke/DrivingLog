//
//  DrivingLog.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation

class DrivingLog: Identifiable, Codable {
    let id: UUID
    let name: String
    var trips: [Trip]
    
    init(name: String) {
        // empty trip list when initialized
        trips = [Trip]()
        id = UUID()
        self.name = name
    }
    
    init() {
        // empty trip list when initialized
        trips = [Trip]()
        id = UUID()
        self.name = "New Log"
    }
    
    func addNewTrip(_ trip: Trip) {
        trips.append(trip)
    }
}

class MockDrivingLog: DrivingLog {
    // create log with fake data for testing
    let mockTrips = [
        Trip(startTime: Date(), endTime: Date() + 60, supervisorName: "Alex"),
        Trip(startTime: Date() + 120, endTime: Date() + 180, supervisorName: "Christian"),
        Trip(startTime: Date() + 240, endTime: Date() + 320, supervisorName: "Thomas")
    ]
    
    override init() {
        super.init(name: "Test log")
        trips = mockTrips
    }
    
    override init(name: String) {
        super.init(name: "Test log")
        trips = mockTrips
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
