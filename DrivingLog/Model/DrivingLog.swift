//
//  DrivingLog.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation

class DrivingLog: ObservableObject, Identifiable, Codable, Hashable {
    
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
    
    // MARK: protocol conformance methods
    
    // Add codable conformance for @Published properties
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
    
    // conform to Equatable protocol (required by hashable)
    static func == (lhs: DrivingLog, rhs: DrivingLog) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable protocol conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: instance methods
    
    func addNewTrip(_ trip: Trip) {
        trips.append(trip)
    }
    
    func editTrip(tripWithChanges: Trip) {
        for (i, trip) in trips.enumerated() {
            if trip.id == tripWithChanges.id {
                trips[i] = tripWithChanges
            }
        }
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
    
    func totalDrivingTimeProportion() -> Double {
        let secondsPerHour = 60.0 * 60.0
        let totalRequiredSeconds = secondsPerHour * 50.0
        return getTotalDrivingTime() / totalRequiredSeconds
    }
    
    func getNightDrivingTime() -> Double {
        var time = 0.0
        for trip in trips {
            time += trip.nightTimeDuration
        }
        return time
    }
    
    func nightDrivingTimeProportion() -> Double {
        let secondsPerHour = 60.0 * 60.0
        let nightRequiredSeconds = secondsPerHour * 10.0
        return getNightDrivingTime() / nightRequiredSeconds
    }
    
    func getDayDrivingTime() -> Double {
        var time = 0.0
        for trip in trips {
            time += trip.dayTimeDuration
        }
        return time
    }
}

// MARK: mock log for testing purposes

class MockDrivingLog: DrivingLog {
    // create log with fake data for testing
    let mockTrips = [
        Trip(startTime: Date(), endTime: Date() + 60, supervisorName: "Alex"),
        Trip(startTime: Date() + 120, endTime: Date() + 180, supervisorName: "Christian"),
        Trip(startTime: Date() + 240, endTime: Date() + 320, supervisorName: "Thomas")
    ]
    
    override init() {
        super.init(name: "Test log")
        trips = createMockTripList()
    }
    
    override init(name: String) {
        super.init(name: "Test log")
        trips = createMockTripList()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // create many trips with random start and end times to fill log PDF
    func createMockTripList() -> [Trip] {
        var trips = [Trip]()
        for i in 1...31 {
            let hour = Int.random(in: 1..<24)
            let minutes = Int.random(in: 1..<60)
            trips.append(getMockTrip(month: 3, day: i, hour: hour, minute: minutes))
        }
        
        for i in 1...31 {
            let hour = Int.random(in: 1..<24)
            let minutes = Int.random(in: 1..<60)
            trips.append(getMockTrip(month: 5, day: i, hour: hour, minute: minutes))
        }
        
        for i in 1...23 {
            let hour = Int.random(in: 1..<24)
            let minutes = Int.random(in: 1..<60)
            trips.append(getMockTrip(month: 6, day: i, hour: hour, minute: minutes))
        }
        
        for i in 1...23 {
            let hour = Int.random(in: 1..<24)
            let minutes = Int.random(in: 1..<60)
            trips.append(getMockTrip(month: 7, day: i, hour: hour, minute: minutes))
        }
        
        return trips
    }
    
    func getMockTrip(month: Int, day: Int, hour: Int, minute: Int) -> Trip {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let endHour: Int
        let random = Int.random(in: 1...5)
        if random > 1 {
            endHour = hour < 23 ? (hour+1) : hour
        } else {
            endHour = hour
        }
        
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        let endHourString = endHour < 10 ? "0\(endHour)" : "\(endHour)"
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
        let monthString = month < 10 ? "0\(month)" : "\(month)"
        let dayString = day < 10 ? "0\(day)" : "\(day)"
        
        let startTime: Date
        let endTime: Date
        let startString = "2022/\(monthString)/\(dayString) \(hourString):00"
        let endString = "2022/\(monthString)/\(dayString) \(endHourString):\(minuteString)"
        
        if let startDate = formatter.date(from: startString) {
            startTime = startDate
        } else {
            print("Error creating date object from \(startString)")
            startTime = Date()
        }
        
        if let endDate = formatter.date(from: endString) {
            endTime = endDate
        } else {
            print("Error creating date object from \(endString)")
            endTime = Date()
        }

        let trip = Trip(startTime: startTime, endTime: endTime, supervisorName: self.name)
        return trip
    }
}
