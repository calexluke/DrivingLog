//
//  MapViewModel.swift
//  DrivingLog
//
//  Created by Christian Garcia on 2/22/22.
//

import SwiftUI
import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 41.4731,
    longitude: 87.0611)
    // zoom level of map. lower number -> higher zoom
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var route = [Coordinate]()
    @Published var routeCL = [CLLocationCoordinate2D]()
    
    var locationManager: CLLocationManager?
    
    override init() {
        // use default values for properties
    }
    
    init(region: MKCoordinateRegion, route: [Coordinate]) {
        self.region = region
        self.route = route
    }
    

    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.startUpdatingLocation()
            updateLocation()
        } else {
            print("Location is off. Go to settings and enable locations services.")
        }
    }

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
    
    func centerMapOnUser() {
        guard let locationManager = locationManager else { return }
        
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            let span = region.span
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorized()
    }
    
    func updateLocation() {
        centerMapOnUser()
        guard let locationManager = locationManager else {
            return
        }
        if let locationUpdate = locationManager.location {
            let currentLocation = Coordinate(latitude: locationUpdate.coordinate.latitude, longitude: locationUpdate.coordinate.longitude)
            self.route.append(currentLocation)
        }
    }
    
    func populateCLCoords() {
        DispatchQueue.main.async {
            self.routeCL = self.route.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
        }
    }
}
