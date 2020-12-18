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
        HStack(spacing: 15){
            if !model.messege.fromUser {
                MemberCircle()
            }
            if model.messege.fromUser {
                Spacer(minLength: 0)
            }
            VStack(alignment: model.messege.fromUser ? .trailing : .leading, spacing: 5, content: {
                Text(model.messege.content)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(MessegeBubble(fromUser:  model.messege.fromUser))
                Text(model.messege.timeStamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(!model.messege.fromUser ? .leading : .trailing , 10)
            })
            if model.messege.fromUser {
                MemberCircle()
            }
            if !model.messege.fromUser {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal)
    }
    func MemberCircle() -> AnyView{
        AnyView(Text(String(model.from.name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background((model.messege.fromUser ? Color.blue : Color.green).opacity(0.5))
            .clipShape(Circle())
            // Context menu For Name Display...
            .contentShape(Circle())
            .contextMenu {
                Text(model.from.name)
                    .fontWeight(.bold)
        })
    }
}

struct MessegeBubble: Shape {
    var fromUser : Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight, fromUser ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        return Path(path.cgPath)
    }
}
