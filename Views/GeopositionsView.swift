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
        ZStack {
            self.map
            self.buttons
            if model.showDeteil {
                self.deteils
            }
        }
    }
    var map: some View {
        Map(coordinateRegion: $model.coordinateRegion,
            annotationItems: model.ItemsForAnotations) { item in
            MapAnnotation(coordinate:  CLLocationCoordinate2D(
                latitude: item.latitude,
                longitude: item.longitude )) {
                CustomAnotationView(name: model.nameFor(item), time: item.timeStamp)
            }
        }
    }
    var buttons: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button(action: self.model.showSelf) {
                    Image(systemName: "location.circle.fill")
                        .padding(.vertical)
                }
                Button(action: self.model.showNext)  {
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
    var deteils: some View {
       VStack{
            Spacer().frame(height: 200)
            Text(model.name).font(.title)
            Text(model.timeAgo).font(.title3)
            Spacer()
       }
    }
}

struct GeopositionsView_Previews: PreviewProvider {
    static var previews: some View {
        GeopositionsView(model: GeopositionsViewModel())
    }
}

struct CustomAnotationView: View {
    @State var isSelect = false
    var name: String
    var time: Date
    var body: some View {
        VStack {
            Text(String(self.name.first!))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background((Color.red))
//                .onTapGesture {
//                    withAnimation() {
//                        self.isSelect.toggle()
//                    }
//                }
                .clipShape(Circle())
            Text(self.name)
                .font(.title)
            if isSelect {
                Text(time.timeAgo())
            } else {
                Spacer().frame(width: 200)
            }
        }.contentShape(Circle())
    }
}

extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
