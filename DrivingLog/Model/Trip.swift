//
//  Trip.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation
import CoreLocation

struct Trip: Identifiable, Codable {
    var id: UUID
    var drivingLogID: UUID
    var startTime: Date
    var endTime: Date
    var supervisorName: String
    var hasLocationData = false
    var locations = [CLLocation]()
    
    init(startTime: Date, endTime: Date, supervisorName: String, logID: UUID) {
        self.startTime = startTime
        self.endTime = endTime
        self.supervisorName = supervisorName
        self.id = UUID()
        self.drivingLogID = logID
    }
    
    init(startTime: Date, endTime: Date, supervisorName: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.supervisorName = supervisorName
        self.id = UUID()
        self.drivingLogID = UUID()
    }
    
    init() {
        self.startTime = Date()
        self.endTime = Date()
        self.supervisorName = ""
        self.id = UUID()
        self.drivingLogID = UUID()
    }
    
    var totaldDurationInSeconds: Double {
        return endTime.timeIntervalSince(startTime)
    }
    
    var dayTimeDuration: Double {
        return totaldDurationInSeconds * getDayTimeRatio(start: startTime, end: endTime)
    }
    
    var nightTimeDuration: Double {
        return totaldDurationInSeconds * (1 - getDayTimeRatio(start: startTime, end: endTime))
    }
    
    /*a function to calculate the ratio of time driven
     between day and night for another calculation*/
    func getDayTimeRatio(start: Date, end: Date) -> Double {
        let startHour = getHour(date: start)
        let endHour = getHour(date: end)
        let startMinutes = getMinutes(date: start)
        let endMinutes = getMinutes(date: end)
        
        var totalMins = 0
        //case needed to determine if trip went
        //from one day to the next
        if endHour < startHour {
            totalMins = convertHourToMin(hours: 24 + (endHour - startHour))
        } else if endHour > startHour {
            totalMins = convertHourToMin(hours: endHour - startHour)
        }
        var ratio = 0.00
        //Day into Night Trip
        if startHour < IntConstants.nightHour && endHour > IntConstants.nightHour {
            let overMins = convertHourToMin(hours: endHour - IntConstants.nightHour) + endMinutes
            ratio = 1 - Double(overMins)/Double(totalMins)
            //Night into Day Trip
        } else if startHour < IntConstants.morningHour && endHour >= IntConstants.morningHour{
            let overMins = convertHourToMin(hours: endHour - IntConstants.morningHour) + endMinutes
            ratio = Double(overMins)/Double(totalMins)
            //Only Day Trip
        } else if startHour >= IntConstants.morningHour &&
                    endHour <= IntConstants.nightHour &&
                    endHour >= startHour {
            ratio = 1
            //Only Night Trip
        } else if  startHour >= IntConstants.nightHour &&
                    endHour <= IntConstants.morningHour &&
                    endHour <= startHour {
            ratio = 0
        }
        return ratio
    }
    
    /*function to convert seconds from durations
     calculated to be displayed to the user*/
    func convertSeconds(timeInSeconds: Int) -> String {
        var mins = timeInSeconds/60
        let minsInHour = (mins/60) * 60 //needed to correct minutes
        let hours = mins/60
        mins = mins - minsInHour
        return (String(hours) + ":" + String(mins))
    }
    
    /*converts hours to minutes
     handy for getting day time ratio*/
    func convertHourToMin(hours: Int) -> Int {
        var mins = 0
        //special case prevention: hours being
        //0 would break the for loop
        if hours != 0 {
            for _ in 0...hours - 1 {
                mins += 60
            }
        }
        return mins
    }
    
    /*returns the hour from the date object*/
    func getHour(date: Date) -> Int {
        // put date in local timezone
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh"
//        formatter.timeZone = .autoupdatingCurrent
//        let localDate = formatter.string(from: date)
//
//        if let hour = Int(localDate) {
//            return hour
//        }
//
        let calendar = Calendar.current
        return calendar.component(.hour, from: date)
    }
    
    /*returns the minutes from the date object*/
    func getMinutes(date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: date)
    }
    
    /*returns the time as a string*/
    func getTimeString(date: Date) -> String {
        let hour = getHour(date: date)
        let minutes = getMinutes(date: date)
        return String(hour) + ":" + String(minutes)
    }
}

// MARK: protocol conformance methods

extension Trip {
    // Add codable conformance: location information is not encoded or decoded
    // (it will be fetched from icloud instead)
    enum CodingKeys: String, CodingKey {
        case id
        case startTime
        case endTime
        case supervisorName
        case hasLocationData
        case drivingLogID
    }

}

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude:Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
