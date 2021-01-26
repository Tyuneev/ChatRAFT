//
//  MembersView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 11.12.2020.
//

import SwiftUI
import Combine

class MembersViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
            
    init(model: Model? = nil) {
        if let model = model {
            self.members = model.members.map {$0.value}
            model
                .$members
                .map({$0.map {$0.value}})
                .assign(to: \.members, on: self)
                .store(in: &cancellables)
        } else {
            self.members = [
                MemberModel(id: "1", name: "Иван Иванов "),
                MemberModel(id: "2", name: "Путин", online: true),
                MemberModel(id: "4", name: "Барыга"),
                MemberModel(id: "6", name: "Мама"),
                MemberModel(id: "7", name: "Папа")
            ]
        }
       
    }
    @Published var members: [MemberModel]
}

struct MembersView: View {
    var model: MembersViewModel
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20){
                ForEach(self.model.members){ member in
                    HStack{
                        Text(String(member.name.first!))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                //(model.messege.fromUser ? Color.blue:
                                (Color.red))
                            .clipShape(Circle())
                        Text(member.name)
                            .font(.title2)
                            .frame(width: .infinity, alignment: .leading)
                        Spacer()
                        if member.online{
                            Circle().foregroundColor(.blue)
                                .frame(width: 15, height: 15)
                        }
                    }.frame(width: .infinity)
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
