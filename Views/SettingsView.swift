//
//  SettingsView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 11.12.2020.
//

import SwiftUI
import MobileCoreServices

struct SettingsView: View {
    @ObservedObject var model: SettingsViewModel
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 20) {
                Text("Участники группы видят вас под имянем:")
                    .font(.title2)
                    .padding(.horizontal)
                if model.editField{
                    HStack {
                        TextField("Новое имя", text: self.$model.name)
                            .padding()
                        Button(action: self.model.chageName){
                            Image(systemName: "checkmark")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                //.frame(width: 150, height: 50)
                                .background(Color("Color"))
                                .clipShape(Capsule())
                                .shadow(radius: 15)
                        }
                    }
                    .background(Capsule().stroke(self.model.name != "" ? Color("Color") : Color.gray, lineWidth: 2))
                } else {
                    HStack {
                        Text(model.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color")).padding(.horizontal)
                        Spacer()
                        Button(action: self.edit){
                            Image(systemName: "pencil")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                //.frame(width: 150, height: 50)
                                .background(Color("Color"))
                                .clipShape(Capsule())
                                .shadow(radius: 15)
                        }
                    }
                }
            }
            Spacer()
            VStack(alignment: .center, spacing: 35){
                Button(action: copy) {
                    Text("Скопировать id вашей группы")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        //.frame(width: 150, height: 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(radius: 15)
                }
                Button(action: model.logOut) {
                    Text("Выйти из аккаунта")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        //.frame(width: 150, height: 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(radius: 15)
                }
                Button(action: model.leftGroup) {
                    Text("Покинуть группу")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        //.frame(width: 150, height: 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(radius: 15)
                }
            }
            Spacer()
        }.padding()
        
    }
    func copy(){
        UIPasteboard.general.setValue(self.model.groupID,
             forPasteboardType: kUTTypePlainText as String)
    }
    func edit(){
        self.model.editField.toggle()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: SettingsViewModel())
    }
}
