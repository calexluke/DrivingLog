//
//  LineMapView.swift
//  DrivingLog
//
//  Created by Thomas Hohnholt on 3/24/22.
//

import SwiftUI
import MapKit

struct LineMapView: UIViewRepresentable {
    
    @ObservedObject var mapViewModel: MapViewModel

//    var lineCoordinates: [CLLocationCoordinate2D] {
//        let coords = mapViewModel.route.map {
//            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
//        }
//        return coords
//    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = mapViewModel.region
        
        let polyline = MKPolyline(coordinates: mapViewModel.routeCL, count: mapViewModel.routeCL.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let polyline = MKPolyline(coordinates: mapViewModel.routeCL, count: mapViewModel.routeCL.count)
        view.addOverlay(polyline)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: LineMapView
    
    init(_ parent: LineMapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor(named: "appAccentColor")
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}
