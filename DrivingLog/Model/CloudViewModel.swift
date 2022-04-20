//
//  CloudViewModel.swift
//  DrivingLog
//
//  Created by Alex Luke on 4/17/22.
//

import Foundation

class CloudViewModel: ObservableObject {
    static let sharedInstance = CloudViewModel()
    
    @Published var cloudSaveError = false
    @Published var fetchTripError = false
    
    var cloudSaveErrorMessage = ""
    var tripErrorMessage = ""
}
