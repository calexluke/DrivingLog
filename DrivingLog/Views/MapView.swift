//
//  MapView.swift
//  DrivingLog
//
//  Created by Thomas Hohnholt on 2/22/22.
//
import SwiftUI
import MapKit


struct MapView: View {

    @State private var region = MKCoordinateRegion(
        //This will be replaced with GPS data, but for now, hardcoded Valparaiso values
        center: CLLocationCoordinate2D(latitude: 41.4731, longitude: 87.0611),

        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)

    )

    var body: some View {
        Map(coordinateRegion: $region)
    }

}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
