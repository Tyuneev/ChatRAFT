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
        switch self.model.userState {
        case .loading:
            LoadinView()
        case .notLogin:
            LogInView(model: LogInViewModel())
        case .login:
            JoinGroupView(model: JoinGroupViewModel())
        case .inGroup:
            tabView
        }
    }
    
    var tabView: some View {
        TabView {
            MembersView(model: MembersViewModel())
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Участники")
                }
            ChatView(model: ChatViewModel())
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Чат")
                }
            GeopositionsView(model: GeopositionsViewModel())
                .ignoresSafeArea(.all, edges: .top)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Локация")
                }
            SettingsView(model: SettingsViewModel())
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
        }
        .accentColor(Color.red)
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
