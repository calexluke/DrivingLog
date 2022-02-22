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
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,
    span: MapDetails.defaultSpan)

    var locationManager: CLLocationManager?

    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
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
                region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                span: MapDetails.defaultSpan)
            @unknown default:
                break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorized()
    }
}
