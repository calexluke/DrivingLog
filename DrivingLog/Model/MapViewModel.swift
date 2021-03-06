//
//  MapViewModel.swift
//  DrivingLog
//
//  Created by Christian Garcia on 2/22/22.
//

import SwiftUI
import MapKit

/*Sets default values for the map like the starting location
and the default zoom on the map*/
enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 41.4731,
    longitude: 87.0611)
    // zoom level of map. lower number -> higher zoom
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var route = [Coordinate]()
    @Published var locations = [CLLocation]()
    @Published var autoCenteringEnabled = true
    
    var locationManager: CLLocationManager?
    
    override init() {
        // use default values for properties
    }
    
    init(region: MKCoordinateRegion) {
        self.region = region
    }
    
    /*A function that checks if the location is enabled. If it is enabled,
    the location manager is created and begins updating the users location.
    If it is not enabled, a message is presented to the user.*/
    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
            updateLocation()
        } else {
            print("Location is off. Go to settings and enable locations services.")
        }
    }

    /*A function that checks if the the location is enabled. There are
    cases for if the location is enabled, denied, restricted, or not
    determined.*/
    func checkLocationAuthorized() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted.")
            case .denied:
                print("You have disabled location for this app. Please enable location services.")
            case .authorizedAlways, .authorizedWhenInUse:
                centerMapOnUser()
            @unknown default:
                break
        }
    }
    
    /*This function centers the map based on the user's current
    location on the map.*/
    func centerMapOnUser() {
        if autoCenteringEnabled {
            guard let locationManager = locationManager,
                  let location = locationManager.location else {
                      return
                  }
            if locationManager.authorizationStatus == .authorizedAlways ||
                locationManager.authorizationStatus == .authorizedWhenInUse {
                let span = region.span // keep the same span, so user can control zoom
                region = MKCoordinateRegion(center: location.coordinate, span: span)
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorized()
    }
    
    /*A function that updates the location of the user and adds
     it to the array of coordinates.*/
    func updateLocation() {
        centerMapOnUser()
        guard let locationManager = locationManager else {
            return
        }
        if let locationUpdate = locationManager.location {
            if locations.isEmpty {
                locations.append(locationUpdate)
            } else {
                // only add new location if the new location is a certain distance from previous
                if let previousLocation = locations.last {
                    let distanceFromPrevious = locationUpdate.distance(from: previousLocation)
                    if distanceFromPrevious > 5 {
                        locations.append(locationUpdate)
                    }
                }
            }
        }
    }
    
    func centerMapOnStartingLocation() {
        guard let startingLocation = locations.first else {
            return
        }
        let startingLocationCL = CLLocationCoordinate2D(latitude: startingLocation.coordinate.latitude,
                                                        longitude: startingLocation.coordinate.longitude)
        region = MKCoordinateRegion(center: startingLocationCL, span: MapDetails.defaultSpan)
    }
}
