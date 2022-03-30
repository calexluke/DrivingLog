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

    var locationManager: CLLocationManager?
    var route = [Coordinate] ()

    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.startUpdatingLocation()
            centerMapOnUser()
            updateLocation(route: route)
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
            
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorized()
    }
    
    func updateLocation(route: [Coordinate]) {
        var locationUpdate: CLLocation!
        locationUpdate = locationManager?.location
        var currentLocation = Coordinate(latitude: locationUpdate.coordinate.latitude, longitude: locationUpdate.coordinate.longitude)
        self.route.append(currentLocation)
    }
}
