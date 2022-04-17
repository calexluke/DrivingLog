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
    static let profileHint = "Name for new profile"
    static let logNameMessage = "Please enter a profile name!"
    static let supervisorAlertMessage = "Please enter the name of your supervisor!"
    static let noSelectedLogMessage = "Please select a log from the list!"
    static let areYouSureTitle = "Are you sure?"
    static let cancelAlertMessage = "You will lose any saved data for this trip"
    static let deletProfileAlertMessage = "You will lose any saved data for this profile"
    static let pdfDateFormat = "MM/dd/yyyy"
    static let CloudContainerID = "iCloud.com.alexluke.DrivingLog"
}

struct FloatConstants {
    static let buttonWidth: CGFloat = 250
    static let buttonHeight: CGFloat = 50
}

struct IntConstants {
    static let nightHour = 18
    static let morningHour = 6
}
