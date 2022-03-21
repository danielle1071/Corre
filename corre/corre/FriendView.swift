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
    
    
    var searchBar: some View {
      
        VStack {
           /*
            Button("Back") {
                sessionManager.showSession()
            }
            */
            /*
            HStack{
            TextField("Enter a new friend", text: self.$newFriend)
            Button(action: self.addFriend, label: {
                Label("Add", systemImage: "plus")
            
            })
                Button ("Pending", action: {
                    sessionManager.showPendingRequests()
                })
            }
            
            */
            //.background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
           /*
            VStack {
                List(sessionManager.databaseManager.friends, id: \.id) { friend in
                    
                        Text("\(friend.username)")
                        .foregroundColor(Color("primaryColor"))
                        .font(Font.custom("VarelaRound-Regular", size: 20))
                    
                }
                
                
            }
           */
        }
       
        
        
    
    }
    
    
    func addFriend(){
        if !sessionManager.databaseManager.checkFriendRequestExist(username: newFriend.lowercased()) {
            sessionManager.databaseManager.friendRequest(username: newFriend.lowercased())
        } else { print("Request already exists") }
        newFriend = ""
        friendStore.friends.append(Friend(id: String(friendStore.friends.count + 1), friendItem: newFriend))
    }
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
        
           
    }
    var body: some View {
        NavigationView{
            ZStack{
                CusColor.backcolor.edgesIgnoringSafeArea(.all)
           
            VStack{
                TextField("Enter a new friend", text: self.$newFriend)
                    .padding()
                    
                
                HStack {
                    List(sessionManager.databaseManager.friends, id: \.id) { friend in
                        
                            Text("\(friend.username)")
                            .listRowBackground(Color("orange"))
                            .foregroundColor(Color("primaryColor"))
                            .font(Font.custom("VarelaRound-Regular", size: 20))
                       
                           
                    }
                    
                }
                //searchBar.padding()
                List{
                    ForEach(self.friendStore.friends){ task in Text(task.friendItem)
                    } .onDelete(perform: self.delete)
                } .navigationBarTitle("Friends")
                    .toolbar{
                        ToolbarItem(placement: .navigation) { // 3
                                    Button("Back") {sessionManager.showSession() }
                                    .foregroundColor(Color("primaryColor"))
                                    .font(Font.custom("VarelaRound-Regular", size: 18))
                                  }
                        ToolbarItem(placement: .navigationBarTrailing) { // 3
                            Button ("Pending") {
                                sessionManager.showPendingRequests()}
                                    .foregroundColor(Color("primaryColor"))
                                    .font(Font.custom("VarelaRound-Regular", size: 18))
                            
                            Button(action: self.addFriend, label: {
                                Label("Add", systemImage: "plus")
                                    .foregroundColor(Color("primaryColor"))
                                    .font(Font.custom("VarelaRound-Regular", size: 18))
                            
                            })

                                  }
                    }
                
                .navigationBarItems(trailing:EditButton())
                }
            
            }
        }
        
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
