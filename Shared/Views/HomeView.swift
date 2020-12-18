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
        TabView {
            MembersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Участники")
                }
            ChatView(model: model.chatViewModel)
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Чат")
                }
            Text("GeopositionsView")
            //GeopositionsView(model: model.geopositionsViewModel)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Локация")
                }
            Text("SettingsView")
            //SettingsView(model: model.settingsViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
        }
        .accentColor(Color.red)
        .font(.headline)
    }
}

struct ChatsListView: View {
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: ChatsView()){
                    Text("Чат1")
                }
                NavigationLink(destination: ChatsView()){
                    Text("Чат2")
                }
                NavigationLink(destination: ChatsView()){
                    Text("Чат3")
                }
                NavigationLink(destination: ChatsView()){
                    Text("Чат4")
                }
            }
        }
    }
}

struct ChatsView: View {
    var body: some View {
        Text("Чат")
    }
}


