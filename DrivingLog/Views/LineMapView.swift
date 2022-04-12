//
//  LineMapView.swift
//  DrivingLog
//
//  Created by Thomas Hohnholt on 3/24/22.
//

import SwiftUI
import MapKit

struct LineMapView: UIViewRepresentable {
    
    //Creating an instance of the MapViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    /// This function initializes an MKMapView to be put on the Trip Detail View.
    /// - Parameter context: The view's initial state.
    /// - Returns: The MKMapView to be displayed.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = mapViewModel.region
        
        let polyline = MKPolyline(coordinates: mapViewModel.routeCL, count: mapViewModel.routeCL.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    /// This function updates the MKMapView to be put on the Trip Detail View.
    /// - Parameter view: The MKMapView to be updated.
    /// - Parameter context: The view's initial state.
    func updateUIView(_ view: MKMapView, context: Context) {
        let polyline = MKPolyline(coordinates: mapViewModel.routeCL, count: mapViewModel.routeCL.count)
        view.addOverlay(polyline)
    }
    
    /// This function makes a Coordinator object.
    /// - Returns: The coordinator object being made.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

//Coordinator class
class Coordinator: NSObject, MKMapViewDelegate {
    var parent: LineMapView
    
    //Initialization Method
    init(_ parent: LineMapView) {
        self.parent = parent
    }
    /// This function returns an MKOverlayRenderer by taking a rendering in a polyline, a mapView, and an overlay. 
    /// - Parameter mapView: The MKMapView to be worked with.
    /// - Parameter overlay: The overlay to be rendered, as it will have the polyline.
    /// - Returns: The visual representation of the MKOverlay.
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
