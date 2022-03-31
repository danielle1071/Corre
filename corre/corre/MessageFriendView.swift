//
//  MessageFriendView.swift
//  corre
//
//  Created by Fabricio Battaglia on 3/25/22.
//

import Foundation
import Amplify
import Combine
import AWSDataStorePlugin
import SwiftUI

struct MessageFriendView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    @ObservedObject var friendStore = FriendStore()
    @State var newFriend: String = ""
    
    
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
        VStack {
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
                        .font(.custom("Varela Round Regular", size: 18))
                })
                Spacer()

            }
            .padding(.all)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
                        
            Text("Message Friends")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("primaryColor"))
            
            HStack {
                List{
                    ForEach(sessionManager.databaseManager.friends, id: \.id) { friend in
                        Button("\(friend.username)", action:{
                            sessionManager.showMessage(friendId: friend.id)
                        })
                            .listRowBackground(Color("orange"))
                            .foregroundColor(Color("primaryColor"))
                            .font(Font.custom("VarelaRound-Regular", size: 18))
                    }
                    //.onClick?
                }
            }
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
}
