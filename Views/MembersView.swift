//
//  MembersView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 11.12.2020.
//

import SwiftUI

struct MembersView: View {
    @ObservedObject var model: MembersViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20){
                ForEach(self.model.members){ member in
                    HStack {
                        Text(String(member.name.first!))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background((Color.red))
                            .clipShape(Circle())
                        Text(member.name)
                            .font(.title2)
                            //.frame(width: .greatestFiniteMagnitude, alignment: .leading)
                        Spacer()
                        if member.online {
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.blue)
                        }
                    }//.frame(width: .greatestFiniteMagnitude)
                }
            }
        }
        .padding()
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(model: MembersViewModel())
    }
}
