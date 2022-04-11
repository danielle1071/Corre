//
// FriendView.swift
//
// Corre
//
// Created by Lucas Morehouse on 2/2/2022
//


import Foundation
import Amplify
import Combine
import AWSDataStorePlugin
import SwiftUI


struct FriendView: View {
    var DEBUG = true
    
    @EnvironmentObject var sessionManager: SessionManger
    @ObservedObject var friendStore = FriendStore()
    // @State var friends: [User] = []
    @State var newFriend: String = ""
    @State var friends = [User]()
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "primaryColor") ?? .red]
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "VarelaRound-Regular", size: 30.0)!, .foregroundColor: UIColor(named: "primaryColor") ?? .red]
        
        UITableView.appearance().backgroundColor = UIColor.clear
        
        // sessionManager.databaseManager.getFriends()
        // friends = sessionManager.databaseManager.friends
    }
    
    var body: some View {
        VStack {
            HStack{
               
                /*
                Button(action: {
                    sessionManager.showSession()
                }, label: {
                    Image(systemName: "arrow.left")
                        .renderingMode(.original)
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(Color("primaryColor"))
                    Text("Back")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 18))
                })
                */
                
                Spacer()
                        
                Button ("View Sent Requests", action: {
                    sessionManager.showPendingRequests()
                })
                .foregroundColor(Color("primaryColor"))
                .font(.custom("Varela Round Regular", size: 18))
               // Spacer()
            }
            .padding(.all)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
                        
            Text("Friends")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            HStack{
                TextField("Enter a new friend", text: self.$newFriend)
                    .shadow(radius: 2.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding([.horizontal], 10)
                    .cornerRadius(16)
                Button(action: self.addFriend, label: {
                    Label("Add Friend", systemImage: "plus")
                        .foregroundColor(Color("primaryColor"))
                })
            }
            .padding(.horizontal)
            
            
            VStack {
                List{
                    ForEach(friends, id: \.id) { friend in
                    // ForEach(friends, id: \.id) { friend in
                        Text("\(friend.username)")
                            .listRowBackground(Color("orange"))
                            .foregroundColor(Color("primaryColor"))
                            .font(Font.custom("VarelaRound-Regular", size: 18))
                    }
                    .onDelete(perform: self.delete2)
                }
            }
            .frame(width: 400)
        }
//        .onReceive(sessionManager.databaseManager.$friends, perform: {_ in
//            friends = sessionManager.databaseManager.friends
//        })
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            friends = sessionManager.databaseManager.friends
        })
    }
    
    func addFriend(){
        if !sessionManager.databaseManager.checkFriendRequestExist(username: newFriend.lowercased()) {
            sessionManager.databaseManager.friendRequest(username: newFriend.lowercased())
        } else {  print("Request already exists") }
        newFriend = ""
        friendStore.friends.append(Friend(id: String(friendStore.friends.count + 1), friendItem: newFriend))
    }
    
    func delete2(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let friend = sessionManager.databaseManager.friends[index]
            
            if (DEBUG) { print("This is the friend to delete \(friend)") }
            
            // sessionManager.databaseManager.deleteEmergencyContact(contactId: friend.id)
            
            sessionManager.databaseManager.removeFriendFromArray(userId: friend.id)
        }
        
        sessionManager.databaseManager.getFriends()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            friends = sessionManager.databaseManager.friends
//        }
        sessionManager.showSession()
    }
    
    func delete(_ offsets: IndexSet){
        offsets.forEach { index in
            let friend = friendStore.friends[index]
            print("Here is the friend being deleted: \(friend)")
        }
        // print(friendStore.friends[atOffset: offsets].friendItem)
        friendStore.friends.remove(atOffsets: offsets)
    }
}


struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
