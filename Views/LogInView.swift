//
//  LogInView.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 19.12.2020.
//

import SwiftUI



struct LogInView: View {
    @ObservedObject var model: LogInViewModel
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 30) {
                Text("Авторизация")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color"))
                TextField("Email", text: self.$model.email)
                    .autocapitalization(.none)
                    .padding()
                    .background(Capsule().stroke(self.model.email != "" ? Color("Color") : Color.gray ,lineWidth: 2))
                    
//                .contentShape(Circle())
//                .shadow(radius: 15)
                HStack(spacing: 15){
                    VStack{
                        if self.model.visible {
                            TextField("Пароль", text: self.$model.password)
                            .autocapitalization(.none)
                        }
                        else {
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
//                .contentShape(Circle())
//                .shadow(radius: 15)
                
                //.padding(.top, 25)
                Button(action: model.logIn) {
                    Text("Войти")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: 150, height: 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(radius: 15)
                }
                NavigationLink(destination: SignInView(model: model.sgnInViewModel())){
                    Text("Регистрация")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: 150, height: 50)
                        .background(Color("Color"))
                        .clipShape(Capsule())
                        .shadow(radius: 15)
                }
                Spacer().frame(height: 150)
            }.padding(.horizontal)
        }.accentColor(Color("Color"))
        .navigationBarHidden(true)
        
    }
}



struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(model: LogInViewModel())
    }
}
