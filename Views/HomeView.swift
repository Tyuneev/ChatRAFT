//
//  HomeView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 10.12.2020.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var model: HomeViewModel
    var body: some View {
        ZStack {
            if self.model.userStatus == .loading {
                LoadinView()
            } else if self.model.userStatus == .notLogIn {
                LogInView(model: self.model.logInViewModel)
            } else if self.model.userStatus == .logIn {
                JoinGroupView(model: self.model.joinGroupViewModel)
            } else {
                tabView
            }
        }
        .alert(isPresented: self.$model.alert, content: self.alert)
    }
    
    var tabView: some View {
        TabView {
            MembersView(model: self.model.membersViewModel)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Участники")
                }
            ChatView(model: self.model.chatViewModel)
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Чат")
                }
            GeopositionsView(model: self.model.geopositionsViewModel)
                .ignoresSafeArea(.all, edges: .top)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Локация")
                }
            SettingsView(model: model.settingsViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
        }
        .accentColor(Color.red)
    }
    func alert() -> Alert{
        return  Alert(title: Text("Ошибка"),
                      message: Text(self.model.alertContent),
                      dismissButton: .default(Text("OK")))
    }
}

struct LoadinView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        return activity
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) { }
}
