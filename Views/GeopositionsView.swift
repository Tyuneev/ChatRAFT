//
//  GeopositionsView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 11.12.2020.
//

import SwiftUI
import MapKit
import Combine

struct GeopositionsView: View {
    @ObservedObject var model: GeopositionsViewModel
    var body: some View {
        ZStack{
            MapView(model: model)
            HStack{
                Spacer()
                VStack {
                    Spacer()
                    Button(action: self.model.showSelf) {
                        Image(systemName: "location.circle.fill")
                            .padding(.vertical)
                    }
                    Button(action: self.model.showNext) {
                        Image(systemName: "chevron.right.circle.fill")
                    }
                    Button(action: self.model.showPrev) {
                        Image(systemName: "chevron.left.circle.fill")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding(.bottom, 40)
                .padding(.trailing)
            }
        }
    }
}




struct MapView: UIViewRepresentable {
    @ObservedObject var model: GeopositionsViewModel
    let map = MKMapView()
    func makeUIView(context: Context) -> MKMapView {
             map.showsUserLocation = true
             let center = CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2707)
             let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
             map.region = region
             return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        for g in self.model.geopositions {
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: g.latitude, longitude: g.longitude)
            point.title = self.model.members[g.user]?.name ?? ""
            point.subtitle = g.timeStamp.description
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(point)
            if let centr = model.inCentr, centr == g, model.needMoveMap {
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centr.latitude, longitude: centr.longitude), span: uiView.region.span)
                uiView.setRegion(region, animated: true)
                uiView.selectAnnotation(point, animated: true)
                model.needMoveMap = false
            }
        }
    }
}

struct GeopositionsView_Previews: PreviewProvider {
    static var previews: some View {
        GeopositionsView(model: GeopositionsViewModel())
    }
}
