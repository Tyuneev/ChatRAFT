//
//  LoadinView.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 16.02.2021.
//

import SwiftUI


struct LoadinView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        return activity
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }
}

