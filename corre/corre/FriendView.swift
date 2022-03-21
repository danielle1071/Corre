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
    
    @EnvironmentObject var sessionManager: SessionManger
    @ObservedObject var friendStore = FriendStore()
    @State var newFriend: String = ""
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }
      
    var body: some View {
        HStack{
            Button(action: {
            sessionManager.showSession()
        }, label: {
            Image(systemName: "arrow.left")
                .renderingMode(.original)
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(Color("primaryColor"))
            Text("Back")
                .foregroundColor(Color("primaryColor"))
            })
            Spacer()
            
            Button ("View Sent Requests", action: {
                sessionManager.showPendingRequests()
            })
            
            .foregroundColor(Color("primaryColor"))
        }
        .padding(.all)

        NavigationView{
            VStack{
                searchBar.padding()
                List{
                    ForEach(self.friendStore.friends) {
                        task in Text(task.friendItem)
                    }
                    .onDelete(perform: self.delete)
                }
                .navigationBarTitle("Friends")
//                .navigationBarItems(trailing: EditButton()
//                                        .foregroundColor(Color("primaryColor")))
            }
            
        }
    }
    
    var searchBar: some View {
        VStack {
//            Button("Back") {
//                sessionManager.showSession()
//            }
            HStack{
            TextField("Enter a new friend", text: self.$newFriend)
            Button(action: self.addFriend, label: {
                Label("Add Friend", systemImage: "plus")
                    .foregroundColor(Color("primaryColor"))
            
            })
//                Button ("Pending", action: {
//                    sessionManager.showPendingRequests()
//                })
            }
            
            List(sessionManager.databaseManager.friends, id: \.id) { friend in
                    Text("\(friend.username)")
                    
            }
            
  
        }
        
    }
    
    func addFriend() {
        if !sessionManager.databaseManager.checkFriendRequestExist(username: newFriend.lowercased()) {
            sessionManager.databaseManager.friendRequest(username: newFriend.lowercased())
        } else { print("Request already exists") }
        newFriend = ""
        friendStore.friends.append(Friend(id: String(friendStore.friends.count + 1), friendItem: newFriend))
    }
    
    func delete(_ offsets: IndexSet){
        offsets.forEach { index in
            let friend = friendStore.friends[index]
            print("Here is the friend being deleted: \(friend)")
        }
//        print(friendStore.friends[atOffset: offsets].friendItem)
        friendStore.friends.remove(atOffsets: offsets)
    }
}


struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}

