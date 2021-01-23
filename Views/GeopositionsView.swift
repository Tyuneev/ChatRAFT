//
//  GeopositionsView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 11.12.2020.
//

import SwiftUI
import MapKit
import Combine

final class GeopositionsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var geopositions = [GeopositionModel]()
    @Published var members = [String: MemberModel]()
    @Published var inCentr: GeopositionModel? = nil
    private var curentIndex = 0
    
    func next() {
        if curentIndex < geopositions.count-1 {
            curentIndex += 1
        } else if curentIndex == geopositions.count - 1 {
            curentIndex = 0
        }
    }
    func prev() {
        if curentIndex > 0 {
            curentIndex -= 1
        } else if geopositions.count > 0  {
            curentIndex = geopositions.count - 1
        }
    }
    func i() {
        
    }
    
    init(model: Model? = nil){
        if let model = model {
            model.$geopositions
                .assign(to: \.geopositions, on: self)
                .store(in: &cancellables)
            model.$members
                .assign(to: \.members, on: self)
                .store(in: &cancellables)
        } else {
            
        }
    }
}

struct GeopositionsView: View {
    @ObservedObject var model: GeopositionsViewModel
    var body: some View {
        ZStack{
            MapView(model: model)
            HStack{
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "location.circle.fill")
                            .padding(.vertical)
                    Image(systemName: "chevron.right.circle.fill")
                    Image(systemName: "chevron.left.circle.fill")
//                    Capsule()
//                        .frame(width: 50, height: 100)
//                        .padding()
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
        for i in self.model.geopositions {
            //if i.key != name{
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
            point.title = self.model.members[i.user]?.name ?? ""
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(point)
            // }
            
        }
    }
}

struct GeopositionsView_Previews: PreviewProvider {
    static var previews: some View {
        GeopositionsView(model: GeopositionsViewModel())
    }
}
