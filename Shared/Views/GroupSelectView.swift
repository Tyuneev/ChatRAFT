//
//  GroupSelectView.swift
//  ChatRAFT (iOS)
//
//  Created by Алексей Тюнеев on 17.12.2020.
//

import SwiftUI

struct GroupSelectView: View {
    @State var id: String = ""
    var body: some View {
        VStack{
            Text("Вступить в группу с ID:")
            TextField(id, text: $id)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
        }
    }
}

struct GroupSelectView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelectView()
    }
}
