//
//  MapView.swift
//  DrivingLog
//
//  Created by Thomas Hohnholt on 2/22/22.
//
import SwiftUI
import MapKit
import CoreLocation


struct MapView: View {

    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
          .ignoresSafeArea()
          .accentColor(Color(.systemPink))
          .onAppear {
            viewModel.checkIfLocationServicesIsEnabled()
          }
    }

}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

//Location authorization stuff
//When integrated, stuff in xcode is going to have to happen
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
  var locationManager: CLLocationManager?
    
  @Published var region = MKCoordinateRegion(
      //This will be replaced with GPS data, but for now, hardcoded Valparaiso values
      center: CLLocationCoordinate2D(latitude: 41.4731, longitude: 87.0611),
      span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)

  )

  func checkIfLocationServicesIsEnabled() {
    if CLLocationManager.locationServicesEnabled(){
      locationManager = CLLocationManager();
      //Something with activity type maybe?
      locationManager!.delegate = self
    }
    else{
      print("Print an alert saying that location is not on")
    }
  }

  private func checkLocationAuthorization() {
    guard let locationManager = locationManager else { return }

    switch locationManager.authorizationStatus{
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .restricted:
        print("Your location is restricted.")
      case .denied:
        print("Your have denied location services, go to settings to change it.")
      case .authorizedAlways:
        break
      case .authorizedWhenInUse:
        region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
      default:
        break
    }
  }
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
    checkLocationAuthorization()
  }
}
