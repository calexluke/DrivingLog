//
//  Trip.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation

struct Trip: Identifiable, Codable {
    let id: UUID
    var startTime: Date
    var endTime: Date
    var supervisorName: String
    
    // array of GPS data?
    // var route:
    
    init(startTime: Date, endTime: Date, supervisorName: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.supervisorName = supervisorName
        self.id = UUID()
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
        
        var totalMins = 0
        //case needed to determine if trip went
        //from one day to the next
        if getHour(date: end) < getHour(date:start) {
            totalMins = convertHourToMin(hours: 24 + (getHour(date: end) - getHour(date: start)))
        } else if getHour(date: end) > getHour(date: start){
            totalMins = convertHourToMin(hours: getHour(date: end) - getHour(date: start))
        }
        var ratio = 0.00
        //Day into Night Trip
        if getHour(date: start) < IntConstants.nightHour && getHour(date: end) > IntConstants.nightHour {
            let overMins = convertHourToMin(hours: getHour(date: end) - IntConstants.nightHour) + getMinutes(date: end)
            ratio = 1 - Double(overMins)/Double(totalMins)
            //Night into Day Trip
        } else if getHour(date: start) < IntConstants.morningHour && getHour(date: end) >= IntConstants.morningHour{
            let overMins = convertHourToMin(hours: getHour(date: end) - IntConstants.morningHour) + getMinutes(date: end)
            ratio = Double(overMins)/Double(totalMins)
            //Only Day Trip
        } else if getHour(date: start) >= IntConstants.morningHour &&
                    getHour(date: end) <= IntConstants.nightHour &&
                    getHour(date: end) > getHour(date:start) {
            ratio = 1
            //Only Night Trip
        } else if  getHour(date: start) >= IntConstants.nightHour &&
                    getHour(date: end) <= IntConstants.morningHour &&
                    getHour(date: end) < getHour(date:start) {
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
            for _ in 0...hours - 1{
                mins += 60
            }
        }
        return mins
    }
    
    /*returns the hour from the date object*/
    func getHour(date: Date) -> Int {
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
