//
//  ChatView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 09.12.2020.
//

import SwiftUI



struct ChatView: View {
    @ObservedObject var model: ChatViewModel
    @State var scrolled = false
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { reader in
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(model.messeges) { messege in
                            MessegeView(model:
                                MessegeViewModel(messege, from: model.senderOf(messege))
                            )
                                .id(messege.id)
                                .onAppear {
                                    if (messege.id == model.messeges.last!.id && !scrolled) {
                                        withAnimation() {
                                            reader.scrollTo(model.messeges.last!.id, anchor: .bottom)
                                            scrolled = true
                                        }
                                    }
                                }
                        }
                        .onChange(of: model.messeges) { value in
                            reader.scrollTo(model.messeges.last!.id, anchor: .bottom)
                        }
                        .onReceive(NotificationCenter.Publisher(
                            center: .default,
                            name: UIResponder.keyboardWillShowNotification
                        )) { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    reader.scrollTo(model.messeges.last!.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    .animation(.default)
                }
            }
            HStack(spacing: 15) {
                TextField("Enter Message", text: $model.messegeText)
                    .padding(.horizontal)
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                Button(action: self.model.sendMessege, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color("Color"))
                        .clipShape(Circle())
                })
            }
            .animation(.default)
            .padding()
        }
    }
}
