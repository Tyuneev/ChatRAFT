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
    let service: MembersServiceProtocol
    init() {
        self.service = FirebaseServices.shered.group.members
        self.service.membersPublisher()
            .sink { member in
                self.members.append(member)
            }
            .store(in: &cancellables)
        self.service.delitedMembersPublisher()
            .sink { member in
                self.dellit(member)
            }
            .store(in: &cancellables)
       
    }
    private func dellit(_ member: Member){
        for (index, mmbr) in members.enumerated() {
            if mmbr.id == member.id {
                members.remove(at: index)
                return
            }
        }
    }
    @Published var members: [Member] = []
}

struct MembersView: View {
    @ObservedObject var model: MembersViewModel
    var body: some View {
        ScrollView{
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
                            .frame(width: .infinity, alignment: .leading)
                        Spacer()
                        if member.online{
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.blue)
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
