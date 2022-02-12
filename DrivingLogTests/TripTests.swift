//
//  TripTests.swift
//  DrivingLogTests
//
//  Created by Alex Luke on 2/11/22.
//

import XCTest
import Foundation
@testable import DrivingLog

class TripTests: XCTestCase {
    let secondsPerHour = 60 * 60
    let supervisorName = "test"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDayAndNightDrivingTime() throws {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let fourPM = formatter.date(from: "2022/02/14 16:00")
        let fourThirtyPM = formatter.date(from: "2022/02/14 16:30")
        let fivePM = formatter.date(from: "2022/02/14 17:00")
        let eightPM = formatter.date(from: "2022/02/14 20:00")
        let tenPM = formatter.date(from: "2022/02/14 22:00")
        
        let twoAM = formatter.date(from: "2022/02/15 02:00")
        let fourAM = formatter.date(from: "2022/02/14 04:00")
        let fourThirtyAM = formatter.date(from: "2022/02/14 04:30")
        let fiveAM = formatter.date(from: "2022/02/14 05:00")
        let eightAM = formatter.date(from: "2022/02/14 08:00")
        let tenAM = formatter.date(from: "2022/02/14 10:00")
        
        // day trip: day time should == total duration
        let dayTrip = Trip(startTime: fourPM!, endTime: fivePM!, supervisorName: supervisorName)
        let dayTrip2 = Trip(startTime: eightAM!, endTime: tenAM!, supervisorName: supervisorName)
        let dayTrip3 = Trip(startTime: fourPM!, endTime: fourThirtyPM!, supervisorName: supervisorName)
        
        XCTAssertEqual(dayTrip.dayTimeDuration, dayTrip.totaldDurationInSeconds)
        XCTAssertEqual(dayTrip2.dayTimeDuration, dayTrip2.totaldDurationInSeconds)
        XCTAssertEqual(dayTrip3.dayTimeDuration, dayTrip3.totaldDurationInSeconds)
        
        // night trip: night time should == total duration
        let nightTrip = Trip(startTime: eightPM!, endTime: tenPM!, supervisorName: supervisorName)
        let nightTrip2 = Trip(startTime: fourAM!, endTime: fiveAM!, supervisorName: supervisorName)
        let nightTrip3 = Trip(startTime: fourAM!, endTime: fourThirtyAM!, supervisorName: supervisorName)
        let nightTrip4 = Trip(startTime: tenPM!, endTime: twoAM!, supervisorName: supervisorName)
        
        XCTAssertEqual(nightTrip.nightTimeDuration, nightTrip.totaldDurationInSeconds)
        XCTAssertEqual(nightTrip2.nightTimeDuration, nightTrip2.totaldDurationInSeconds)
        XCTAssertEqual(nightTrip3.nightTimeDuration, nightTrip3.totaldDurationInSeconds)
        XCTAssertEqual(nightTrip4.nightTimeDuration, nightTrip4.totaldDurationInSeconds)
        
        // equal time day and night trip: night time should == total duration * 0.5, and vice versa
        let transitionTrip = Trip(startTime: fourPM!, endTime: eightPM!, supervisorName: supervisorName)
        let transitionTrip2 = Trip(startTime: fourAM!, endTime: eightAM!, supervisorName: supervisorName)
        let transitionTrip3 = Trip(startTime: tenPM!, endTime: twoAM!, supervisorName: supervisorName)
        
        XCTAssertEqual(transitionTrip.nightTimeDuration, transitionTrip.totaldDurationInSeconds * 0.5)
        XCTAssertEqual(transitionTrip.dayTimeDuration, transitionTrip.totaldDurationInSeconds * 0.5)
        XCTAssertEqual(transitionTrip2.nightTimeDuration, transitionTrip2.totaldDurationInSeconds * 0.5)
        XCTAssertEqual(transitionTrip2.dayTimeDuration, transitionTrip2.totaldDurationInSeconds * 0.5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
