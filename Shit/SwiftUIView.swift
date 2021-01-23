//
//  SwiftUIView.swift
//  ChatRAFT
//
//  Created by Алексей Тюнеев on 08.12.2020.
//

import SwiftUI
import Firebase



struct Home : View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View{
        NavigationView{
            VStack{
                if self.status {
                    Homescreen()
                }
                else {
                    ZStack {
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show){
                            Text("")
                        }
                        .hidden()
                        Login(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in

                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Homescreen : View {
    var body: some View{
        VStack{
            Text("Logged successfully")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            Button(action: {
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }) {
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
        }
    }
}

struct Login : View {
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    var body: some View {
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader { _ in
                    VStack{
                        //Image("logo")
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                        HStack(spacing: 15){
                            VStack{
                                if self.visible {
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }

                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        HStack{
                            Spacer()
                            Button(action: {
                                self.reset()
                            }) {
                                Text("Forget password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color"))
                            }
                        }
                        .padding(.top, 20)
                        Button(action: {
                            self.verify()
                        }) {
                            Text("Log in")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                }
                Button(action: {
                    self.show.toggle()
                }) {
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Color"))
                }
                .padding()
            }
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    func verify(){
        if self.email != "" && self.pass != ""{
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else{
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }

    func reset(){
        if self.email != ""{
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}

struct SignUp : View {
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""

    var body: some View{
        ZStack{
            ZStack(alignment: .topLeading) {
                GeometryReader{_ in
                    VStack{
                        Image("logo")
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        HStack(spacing: 15){
                            VStack{
                                if self.visible{
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    SecureField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)

                        HStack(spacing: 15){
                            VStack{
                                if self.revisible{
                                    TextField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    SecureField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                self.revisible.toggle()
                            }) {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        Button(action: {
                            self.register()
                        }) {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                }
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Color"))
                }
                .padding()
            }
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func register(){
        if self.email != ""{
            if self.pass == self.repass{
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    if err != nil{
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    print("success")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
            else{
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }
        else{
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
}


struct ErrorView : View {
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View{
        GeometryReader{_ in
            VStack{
                HStack{
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    Spacer()
                }
                .padding(.horizontal, 25)
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                .foregroundColor(self.color)
                .padding(.top)
                .padding(.horizontal, 25)

                Button(action: {
                    self.alert.toggle()
                }) {
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}


////============================
//// ContentView.swift
////import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//
//        Home()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
////Home.swift
//
//import SwiftUI
//
//struct Home: View {
//    @StateObject var homeData = HomeModel()
//    @AppStorage("current_user") var user = ""
//    @State var scrolled = false
//    var body: some View {
//
//        VStack(spacing: 0){
//
//            HStack{
//
//                Text("Global Chat")
//                    .font(.title)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.white)
//
//                Spacer(minLength: 0)
//            }
//            .padding()
//            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
//            .background(Color("Color"))
//
//            ScrollViewReader{reader in
//
//                ScrollView{
//
//                    VStack(spacing: 15){
//
//                        ForEach(homeData.msgs){msg in
//
//                           ChatRow(chatData: msg)
//                            .onAppear{
//                                // First Time Scroll
//                                if msg.id == self.homeData.msgs.last!.id && !scrolled{
//
//                                    reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
//                                    scrolled = true
//                                }
//                            }
//                        }
//                        .onChange(of: homeData.msgs, perform: { value in
//
//                            // You can restrict only for current user scroll....
//                            reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
//                        })
//                    }
//                    .padding(.vertical)
//                }
//            }
//
//            HStack(spacing: 15){
//
//                TextField("Enter Message", text: $homeData.txt)
//                    .padding(.horizontal)
//                    // Fixed Height For Animation...
//                    .frame(height: 45)
//                    .background(Color.primary.opacity(0.06))
//                    .clipShape(Capsule())
//
//                if homeData.txt != ""{
//
//                    Button(action: homeData.writeMsg, label: {
//
//                        Image(systemName: "paperplane.fill")
//                            .font(.system(size: 22))
//                            .foregroundColor(.white)
//                            .frame(width: 45, height: 45)
//                            .background(Color("Color"))
//                            .clipShape(Circle())
//                    })
//                }
//            }
//            .animation(.default)
//            .padding()
//        }
//        .onAppear(perform: {
//
//            homeData.onAppear()
//        })
//        .ignoresSafeArea(.all, edges: .top)
//    }
//}
//
//// ChatRow.swift
//
//import SwiftUI
//
//struct ChatRow: View {
//    var chatData : MsgModel
//    @AppStorage("current_user") var user = ""
//    var body: some View {
//
//        HStack(spacing: 15){
//
//            // NickName View...
//
//            if chatData.user != user{
//
//                NickName(name: chatData.user)
//            }
//
//            if chatData.user == user{Spacer(minLength: 0)}
//
//            VStack(alignment: chatData.user == user ? .trailing : .leading, spacing: 5, content: {
//
//                Text(chatData.msg)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color("Color"))
//                // Custom Shape...
//                    .clipShape(ChatBubble(myMsg: chatData.user == user))
//
//                Text(chatData.timeStamp,style: .time)
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                    .padding(chatData.user != user ? .leading : .trailing , 10)
//            })
//
//            if chatData.user == user{
//
//                NickName(name: chatData.user)
//            }
//
//            if chatData.user != user{Spacer(minLength: 0)}
//        }
//        .padding(.horizontal)
//        // For SCroll Reader....
//        .id(chatData.id)
//    }
//}
//
//struct NickName : View {
//
//    var name : String
//    @AppStorage("current_user") var user = ""
//
//    var body: some View{
//
//        Text(String(name.first!))
//            .fontWeight(.heavy)
//            .foregroundColor(.white)
//            .frame(width: 50, height: 50)
//            .background((name == user ? Color.blue : Color.green).opacity(0.5))
//            .clipShape(Circle())
//            // COntext menu For Name Display...
//            .contentShape(Circle())
//            .contextMenu{
//
//                Text(name)
//                    .fontWeight(.bold)
//            }
//    }
//}
//
////ChatBubble.swift
//import SwiftUI
//
//struct ChatBubble: Shape {
//
//    var myMsg : Bool
//
//    func path(in rect: CGRect) -> Path {
//
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
//
//        return Path(path.cgPath)
//    }
//}
//
////MsgModel.swift
//
//
//// For Onchange...
//struct MsgModel: Codable,Identifiable,Hashable {
//
//    @DocumentID var id : String?
//    var msg : String
//    var user : String
//    var timeStamp: Date
//
//    enum CodingKeys: String,CodingKey {
//        case id
//        case msg
//        case user
//        case timeStamp
//    }
//}
//
//// HomeModel.swift
//import SwiftUI
//import Firebase
//
//class HomeModel: ObservableObject{
//
//    @Published var txt = ""
//    @Published var msgs : [MsgModel] = []
//    @AppStorage("current_user") var user = ""
//    let ref = Firestore.firestore()
//
//    init() {
//        readAllMsgs()
//    }
//
//    func onAppear(){
//
//        // Checking whether user is joined already....
//
//        if user == ""{
//            // Join Alert...
//
//            UIApplication.shared.windows.first?.rootViewController?.present(alertView(), animated: true)
//        }
//    }
//
//    func alertView()->UIAlertController{
//
//        let alert = UIAlertController(title: "Join Chat !!!", message: "Enter Nick Name", preferredStyle: .alert)
//
//        alert.addTextField { (txt) in
//            txt.placeholder = "eg Kavsoft"
//        }
//
//        let join = UIAlertAction(title: "Join", style: .default) { (_) in
//
//            // checking for empty click...
//
//            let user = alert.textFields![0].text ?? ""
//
//            if user != ""{
//
//                self.user = user
//                return
//            }
//
//            // repromiting alert view...
//
//            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
//        }
//
//        alert.addAction(join)
//
//        return alert
//    }
//
//    func readAllMsgs(){
//
//        ref.collection("Msgs").order(by: "timeStamp", descending: false).addSnapshotListener { (snap, err) in
//
//            if err != nil{
//                print(err!.localizedDescription)
//                return
//            }
//
//            guard let data = snap else{return}
//
//            data.documentChanges.forEach { (doc) in
//
//                // adding when data is added...
//
//                if doc.type == .added{
//
//                    let msg = try! doc.document.data(as: MsgModel.self)!
//
//                    DispatchQueue.main.async {
//                        self.msgs.append(msg)
//                    }
//                }
//            }
//        }
//    }
//
//    func writeMsg(){
//
//        let msg = MsgModel(msg: txt, user: user, timeStamp: Date())
//
//        let _ = try! ref.collection("Msgs").addDocument(from: msg) { (err) in
//
//            if err != nil{
//                print(err!.localizedDescription)
//                return
//            }
//
//        }
//
//        self.txt = ""
//    }
//}// ContentView.swift
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//
//        Home()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
////Home.swift
//
//import SwiftUI
//
//struct Home: View {
//    @StateObject var homeData = HomeModel()
//    @AppStorage("current_user") var user = ""
//    @State var scrolled = false
//    var body: some View {
//
//        VStack(spacing: 0){
//
//            HStack{
//
//                Text("Global Chat")
//                    .font(.title)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.white)
//
//                Spacer(minLength: 0)
//            }
//            .padding()
//            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
//            .background(Color("Color"))
//
//            ScrollViewReader{reader in
//
//                ScrollView{
//
//                    VStack(spacing: 15){
//
//                        ForEach(homeData.msgs){msg in
//
//                           ChatRow(chatData: msg)
//                            .onAppear{
//                                // First Time Scroll
//                                if msg.id == self.homeData.msgs.last!.id && !scrolled{
//
//                                    reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
//                                    scrolled = true
//                                }
//                            }
//                        }
//                        .onChange(of: homeData.msgs, perform: { value in
//
//                            // You can restrict only for current user scroll....
//                            reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
//                        })
//                    }
//                    .padding(.vertical)
//                }
//            }
//
//            HStack(spacing: 15){
//
//                TextField("Enter Message", text: $homeData.txt)
//                    .padding(.horizontal)
//                    // Fixed Height For Animation...
//                    .frame(height: 45)
//                    .background(Color.primary.opacity(0.06))
//                    .clipShape(Capsule())
//
//                if homeData.txt != ""{
//
//                    Button(action: homeData.writeMsg, label: {
//
//                        Image(systemName: "paperplane.fill")
//                            .font(.system(size: 22))
//                            .foregroundColor(.white)
//                            .frame(width: 45, height: 45)
//                            .background(Color("Color"))
//                            .clipShape(Circle())
//                    })
//                }
//            }
//            .animation(.default)
//            .padding()
//        }
//        .onAppear(perform: {
//
//            homeData.onAppear()
//        })
//        .ignoresSafeArea(.all, edges: .top)
//    }
//}
//
//// ChatRow.swift
//
//import SwiftUI
//
//struct ChatRow: View {
//    var chatData : MsgModel
//    @AppStorage("current_user") var user = ""
//    var body: some View {
//
//        HStack(spacing: 15){
//
//            // NickName View...
//
//            if chatData.user != user{
//
//                NickName(name: chatData.user)
//            }
//
//            if chatData.user == user{Spacer(minLength: 0)}
//
//            VStack(alignment: chatData.user == user ? .trailing : .leading, spacing: 5, content: {
//
//                Text(chatData.msg)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color("Color"))
//                // Custom Shape...
//                    .clipShape(ChatBubble(myMsg: chatData.user == user))
//
//                Text(chatData.timeStamp,style: .time)
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                    .padding(chatData.user != user ? .leading : .trailing , 10)
//            })
//
//            if chatData.user == user{
//
//                NickName(name: chatData.user)
//            }
//
//            if chatData.user != user{Spacer(minLength: 0)}
//        }
//        .padding(.horizontal)
//        // For SCroll Reader....
//        .id(chatData.id)
//    }
//}
//
//struct NickName : View {
//
//    var name : String
//    @AppStorage("current_user") var user = ""
//
//    var body: some View{
//
//        Text(String(name.first!))
//            .fontWeight(.heavy)
//            .foregroundColor(.white)
//            .frame(width: 50, height: 50)
//            .background((name == user ? Color.blue : Color.green).opacity(0.5))
//            .clipShape(Circle())
//            // COntext menu For Name Display...
//            .contentShape(Circle())
//            .contextMenu{
//
//                Text(name)
//                    .fontWeight(.bold)
//            }
//    }
//}
//
////ChatBubble.swift
//import SwiftUI
//
//struct ChatBubble: Shape {
//
//    var myMsg : Bool
//
//    func path(in rect: CGRect) -> Path {
//
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
//
//        return Path(path.cgPath)
//    }
//}
//
////MsgModel.swift
//import SwiftUI
//
//
//// For Onchange...
//struct MsgModel: Codable,Identifiable,Hashable {
//
//    @DocumentID var id : String?
//    var msg : String
//    var user : String
//    var timeStamp: Date
//
//    enum CodingKeys: String,CodingKey {
//        case id
//        case msg
//        case user
//        case timeStamp
//    }
//}
//
//// HomeModel.swift
//import SwiftUI
//import Firebase
//
//class HomeModel: ObservableObject{
//
//    @Published var txt = ""
//    @Published var msgs : [MsgModel] = []
//    @AppStorage("current_user") var user = ""
//    let ref = Firestore.firestore()
//
//    init() {
//        readAllMsgs()
//    }
//
//    func onAppear(){
//
//        // Checking whether user is joined already....
//
//        if user == ""{
//            // Join Alert...
//
//            UIApplication.shared.windows.first?.rootViewController?.present(alertView(), animated: true)
//        }
//    }
//
//    func alertView()->UIAlertController{
//
//        let alert = UIAlertController(title: "Join Chat !!!", message: "Enter Nick Name", preferredStyle: .alert)
//
//        alert.addTextField { (txt) in
//            txt.placeholder = "eg Kavsoft"
//        }
//
//        let join = UIAlertAction(title: "Join", style: .default) { (_) in
//
//            // checking for empty click...
//
//            let user = alert.textFields![0].text ?? ""
//
//            if user != ""{
//
//                self.user = user
//                return
//            }
//
//            // repromiting alert view...
//
//            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
//        }
//
//        alert.addAction(join)
//
//        return alert
//    }
//
//    func readAllMsgs(){
//
//        ref.collection("Msgs").order(by: "timeStamp", descending: false).addSnapshotListener { (snap, err) in
//
//            if err != nil{
//                print(err!.localizedDescription)
//                return
//            }
//
//            guard let data = snap else{return}
//
//            data.documentChanges.forEach { (doc) in
//
//                // adding when data is added...
//
//                if doc.type == .added{
//
//                    let msg = try! doc.document.data(as: MsgModel.self)!
//
//                    DispatchQueue.main.async {
//                        self.msgs.append(msg)
//                    }
//                }
//            }
//        }
//    }
//
//    func writeMsg(){
//
//        let msg = MsgModel(msg: txt, user: user, timeStamp: Date())
//
//        let _ = try! ref.collection("Msgs").addDocument(from: msg) { (err) in
//
//            if err != nil{
//                print(err!.localizedDescription)
//                return
//            }
//
//        }
//
//        self.txt = ""
//    }
//}
