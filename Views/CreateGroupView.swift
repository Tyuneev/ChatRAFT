//
//  CreateGroupView.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 19.12.2020.
//

import SwiftUI

struct CreateGroupView: View {
    @ObservedObject var model: CreateGroupViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            Text("Создать группу")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Color"))
            TextField("Ваше имя", text: self.$model.name)
                .padding()
                .background(Capsule().stroke(self.model.name != "" ? Color("Color") : Color.gray ,lineWidth: 2))
                .shadow(radius: 15)
            Button(action: model.createGroup) {
                Text("Создать")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: 150, height: 50)
                    .background(Color("Color"))
                    .clipShape(Capsule())
                    .shadow(radius: 15)
            }
            Spacer().frame(height: 280)
        }.padding(.horizontal)
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(model: CreateGroupViewModel())
    }
}
