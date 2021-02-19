//
//  JoinGroupView.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 19.12.2020.
//

import SwiftUI

struct JoinGroupView: View {
    @ObservedObject var model: JoinGroupViewModel
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 30) {
                Text("Присоединение к группе")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color"))
                    .layoutPriority(2)
                TextField("ID группы", text: self.$model.id)
                    .padding()
                    .background(Capsule().stroke(self.model.id != "" ? Color("Color") : Color.gray ,lineWidth: 2))
//                    .contentShape(Circle())
//                    .shadow(radius: 15)
                TextField("Ваше имя", text: self.$model.name)
                    .autocapitalization(.none)
                    .padding()
                    .background(Capsule().stroke(self.model.name != "" ? Color("Color") : Color.gray ,lineWidth: 2))
//                    .contentShape(Circle())
//                    .shadow(radius: 15)
                if model.loading {
                    LoadinView()
                        .frame(width: 50, height: 50)
                } else {
                    Button(action: model.joinGroup) {
                        Text("Присоедениться")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: 200, height: 50)
                            .background(Color("Color"))
                            .clipShape(Capsule())
                            .shadow(radius: 15)
                    }
                }
                NavigationLink(destination: CreateGroupView(model: CreateGroupViewModel())){
                    Text("Создать группу")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: 200, height: 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(radius: 15)
                }
                Spacer()
                    .frame(minHeight: 0, idealHeight: 150)
            }.padding(.horizontal)
        }.accentColor(Color("Color"))
        .alert(isPresented: $model.alertIsPresented) {
            Alert(title: Text("Ошибка"),
                  message: Text("model.alertText"),
                  dismissButton: .default(Text("Ok")))
        }
        .alert(isPresented: $model.alertIsPresented) {
            Alert(title: Text("Ошибка"),
                  message: Text(model.alertText),
                  dismissButton: .default(Text("Ok")))
        }
        .navigationBarHidden(true)
    }
}

struct JoinGroupView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGroupView(model: JoinGroupViewModel())
    }
}
