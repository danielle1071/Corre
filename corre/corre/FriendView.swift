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
    
    @ObservedObject var friendStore = FriendStore()
    @State var newFriend: String = ""
    
    var searchBar: some View{
        HStack{
            TextField("Enter a new friend", text: self.$newFriend)
            Button(action: self.addFriend, label: {
                Label("Add", systemImage: "plus")
            })
        }
    }
    
    func addFriend(){
        friendStore.friends.append(Friend(id: String(friendStore.friends.count + 1), friendItem: newFriend))
    }
    
    var body: some View {
        NavigationView{
            VStack{
                searchBar.padding()
                List{
                    ForEach(self.friendStore.friends){ task in Text(task.friendItem)
                    } .onDelete(perform: self.delete)
                } .navigationBarTitle("Friends")
                .navigationBarItems(trailing:EditButton())
                }
            }
        }
    
    func delete(at offsets: IndexSet){
        friendStore.friends.remove(atOffsets: offsets)
    }
}


struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
