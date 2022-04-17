//
//  CloudManager.swift
//  DrivingLog
//
//  Created by Alex Luke on 4/12/22.
//

import Foundation
import CloudKit
import CoreLocation

extension Trip {
    enum RecordKey: String {
        case id
        case startTime
        case endTime
        case supervisorName
        case hasLocationData
        case locations
        case logID
    }
}

// used to access record keys with RecordKey enum subscripts
extension CKRecord {
    subscript(key: Trip.RecordKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}

class CloudManager {
    
    let container = CKContainer(identifier: StringConstants.CloudContainerID)
    let tripRecord = "tripRecord"
    let logRecord = "logRecord"

    init() {
        // TODO: move this to a higher level scope in the app
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userAccountChanged),
                                               name: .CKAccountChanged,
                                               object: nil)
        
    }
    
    func printUserRecord() {
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                print("error getting recordID: \(error!.localizedDescription)")
                return
            }
            print("Got user record ID \(recordID.recordName).")
            
            // `recordID` is the record ID returned from CKContainer.fetchUserRecordID
            self.container.publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    print("error getting user record: \(error!.localizedDescription)")
                    return
                }

                print("The user record is: \(record)")
            }
        }
    }
    
    func tripFromRecord(_  record: CKRecord) -> Trip? {
        guard let idString = record[.id] as? String,
              let logIDString = record[.logID] as? String,
              let startTime = record[.startTime] as? Date,
              let endTime = record[.endTime] as? Date,
              let supervisorName = record[.supervisorName] as? String,
              let hasLocationDataInt = record[.hasLocationData] as? Int,
              let locations = record[.locations] as? [CLLocation] else {
                  print("error parsing trip record from CloudKit")
                  return nil
              }
        
        var trip = Trip(startTime: startTime, endTime: endTime, supervisorName: supervisorName)
        if let id = UUID(uuidString: idString),
           let logID = UUID(uuidString: logIDString){
            trip.id = id
            trip.drivingLogID = logID
        } else {
            print("error converting string to UUID")
        }
        trip.hasLocationData = Utility.boolFromInt(hasLocationDataInt)
        trip.locations = locations
        return trip
    }
    
    func recordFromTrip(_ trip: Trip) -> CKRecord {
        let newRecord = CKRecord(recordType: tripRecord)
        newRecord[.id] = trip.id.uuidString
        newRecord[.logID] = trip.id.uuidString
        newRecord[.startTime] = trip.startTime
        newRecord[.endTime] = trip.endTime
        newRecord[.supervisorName] = trip.supervisorName
        newRecord[.hasLocationData] = Utility.intFromBool(trip.hasLocationData)
        newRecord[.locations] = trip.locations
        return newRecord
    }
    
    func fetchTripRecords(query: CKQuery, completionHandler: @escaping (Trip?, Error?) -> Void) {
        let queryOperation = CKQueryOperation(query: query)
        var tripRecords = [CKRecord]()
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { recordID, recordResult in
                switch recordResult {
                    case .success(let record):
                        tripRecords.append(record)
                        if let trip = self.tripFromRecord(record) {
                            print("fetched trip")
                            DispatchQueue.main.async {
                                completionHandler(trip, nil)
                            }
                        }
                        
                    case.failure(let error):
                        print("error getting record: \(error.localizedDescription)")
                        completionHandler(nil, error)
                }
            }
        } else {
            // Fallback on earlier versions
            queryOperation.recordFetchedBlock = { record in
                tripRecords.append(record)
                if let trip = self.tripFromRecord(record) {
                    print("fetched trip")
                    DispatchQueue.main.async {
                        completionHandler(trip, nil)
                    }
                }
            }
        }
        
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { result in
                switch result {
                    case.success(let cursor):
                        if let cursor = cursor {
                            print("cursor: \(cursor)")
                        }
                        print("data records: ")
                        print(tripRecords)
                    case.failure(let error):
                        print("error during records query: \(error.localizedDescription)")
                        completionHandler(nil, error)
                }
            }
        } else {
            // Fallback on earlier versions
            queryOperation.queryCompletionBlock = { cursor, error in
                // recipeRecords now contains all records fetched during the lifetime of the operation
                if let error = error {
                    print("error fetchign trip records: \(error.localizedDescription)")
                    completionHandler(nil, error)
                }
                print("finished fetching trip records: ")
                print(tripRecords)
            }
        }
        container.privateCloudDatabase.add(queryOperation)

    }
    
    func fetchTrip(id: UUID, completionHandler: @escaping (Trip?, Error?) -> Void) {
        let idString = id.uuidString
        let predicate = NSPredicate(format: "id == %@", idString)
        let query = CKQuery(recordType: tripRecord, predicate: predicate)
        fetchTripRecords(query: query, completionHandler: completionHandler)
    }
    
    // load all records of the specific type
    func fetchAllTrips(completionHandler: @escaping (Trip?, Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: tripRecord, predicate: predicate)
        fetchTripRecords(query: query, completionHandler: completionHandler)
    }
    
    func saveTrip(_ trip: Trip) {
        // create record from data object
        let newRecord = recordFromTrip(trip)
        saveRecord(newRecord)
    }
    
    private func saveRecord(_ record: CKRecord) {
        container.privateCloudDatabase.save(record) { _, error in
            guard error == nil else {
                // top-notch error handling
                print("error saving record: \(error!.localizedDescription)")
                return
            }
            print("Successfully updated record")
        }
    }
    
    // add to a class that won't be deallocated during app run
    @objc func userAccountChanged() {
        // may need to respond to this change at some point
        print("user changed iCloud account")
    }
}

