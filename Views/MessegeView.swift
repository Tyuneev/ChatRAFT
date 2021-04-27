//
//  MessegeView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 09.12.2020.
//

import SwiftUI

struct MessegeView: View {
    let model : MessegeViewModel
    var body: some View {
        VStack {
            HStack(spacing: 15){
                if !model.fromUser {
                    memberCircle
                }
                if model.fromUser {
                    Spacer(minLength: 0)
                }
                VStack(alignment: model.fromUser ? .trailing : .leading, spacing: 5) {
                    Text(model.messege.content)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("Color"))
                        .clipShape(MessegeBubble(fromUser:  model.fromUser))
                    Text(model.messege.timeStamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(!model.fromUser ? .leading : .trailing , 10)
                }
//                if model.fromUser {
//                    memberCircle
//                }
                if !model.fromUser {
                    Spacer(minLength: 0)
                }
            }
            .padding(.horizontal)
        }
    }
    var memberCircle: some View{
        Text(String(model.from.name.first ?? "!"))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background((model.fromUser ? Color.blue : Color.green).opacity(0.5))
            .clipShape(Circle())
            .contentShape(Circle())
            .contextMenu {
                Text(model.from.name)
                    .fontWeight(.bold)
            }
    }
}

struct MessegeBubble: Shape {
    var fromUser : Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight, fromUser ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        return Path(path.cgPath)
    }
}
