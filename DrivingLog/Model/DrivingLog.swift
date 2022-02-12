//
//  DrivingLog.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation

class DrivingLog: ObservableObject, Identifiable, Codable {
    let id: UUID
    @Published var name: String
    @Published var trips: [Trip]
    
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
    
    // MARK: Add codable conformance for @Published properties
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case trips
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        trips = try container.decode([Trip].self, forKey: .trips)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(trips, forKey: .trips)
    }
    
    // MARK: instance methods
    
    func addNewTrip(_ trip: Trip) {
        trips.append(trip)
    }
    
    func setName(_ newName: String) {
        name = newName
    }
    
    func getTotalDrivingTime() -> Double {
        var time = 0.0
        for trip in trips {
            time += trip.totaldDurationInSeconds
        }
        return time
    }
    
    func getNightDrivingTime() -> Double {
        var time = 0.0
        for trip in trips {
            time += trip.nightTimeDuration
        }
        return time
    }
    
    func getDayDrivingTime() -> Double {
        var time = 0.0
        for trip in trips {
            time += trip.dayTimeDuration
        }
        return time
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
