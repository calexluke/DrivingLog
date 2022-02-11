//
//  Constants.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

import Foundation
import SwiftUI

struct StringConstants {
    static let listOfLogsKey = "drivingLogs"
    static let supervisorHint = "Enter supervisor name"
    static let supervisorAlertMessage = "Please enter the name of your supervisor!"
    static let cancelAlertTitle = "Are you sure?"
    static let cancelAlertMessage = "You will lose any saved data for this trip"
}

struct FloatConstants {
    static let buttonWidth: CGFloat = 250
    static let buttonHeight: CGFloat = 50
}

struct IntConstants {
    static let nightHour = 18
    static let morningHour = 6
}
