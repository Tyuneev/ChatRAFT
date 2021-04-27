//
//  SignInView.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 19.12.2020.
//

import SwiftUI


struct SignInView: View {
    @ObservedObject var model: SignInViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("Регистрация")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Color"))
            TextField("Email", text: self.$model.email)
                .autocapitalization(.none)
                .padding()
                .background(Capsule().stroke(self.model.email != "" ? Color("Color") : Color.gray ,lineWidth: 2))
            HStack(spacing: 15){
                VStack{
                    if self.model.visible{
                        TextField("Пароль", text: self.$model.password)
                        .autocapitalization(.none)
                    }
                    else{
                        SecureField("Пароль", text: self.$model.password)
                        .autocapitalization(.none)
                    }
                }
                Button(action: {
                    self.model.visible.toggle()
                }) {
                    Image(systemName: self.model.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color("Color"))
                }
            }
            .padding()
            .background(Capsule().stroke(self.model.password != "" ? Color("Color") : Color.gray, lineWidth: 2))
            //.contentShape(Circle())
            //.shadow(radius: 15)
            
            HStack(spacing: 15){
                VStack{
                    if self.model.visible{
                        TextField("Пароль повторно", text: self.$model.passwordRepeat)
                        .autocapitalization(.none)
                    }
                    else{
                        SecureField("Пароль повторно", text: self.$model.passwordRepeat)
                        .autocapitalization(.none)
                    }
                }
                Button(action: {
                    self.model.visible.toggle()
                }) {
                    Image(systemName: self.model.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color("Color"))
                }
            }
            .padding()
            .background(Capsule().stroke((self.model.password != "" && self.model.password == self.model.passwordRepeat) ? Color("Color") : Color.gray, lineWidth: 2))
//            .contentShape(Circle())
//            .shadow(radius: 15)
            //.padding(.top, 25)
            if model.loading {
                LoadinView()
                    .frame(width: 50, height: 50)
            } else {
                Button(action: model.createUser) {
                    Text("Зарегистрироваться ")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: 250, height: 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(radius: 15)
                }
            }
            Spacer().frame(height: 150)
        }.padding(.horizontal)
        .alert(isPresented: $model.alertIsPresented) {
            Alert(title: Text("Ошибка"),
                  message: Text(model.alertText),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(model: SignInViewModel())
    }
}
