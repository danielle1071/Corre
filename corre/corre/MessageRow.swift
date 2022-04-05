//
//  MessageRow.swift
//  corre
//
//  Created by Fabricio Battaglia on 2/18/22.
//

import Foundation

import SwiftUI
import Amplify

struct MessageRow: View {

    @ObservedObject var messageManager = MessageManager()
    //@ObservedObject var sessionManager = SessionManger()
    //SessionManager has to be an Environment object or it won't find currentUser
    @EnvironmentObject var sessionManager: SessionManger
    
    let message: Message
    let isCurrentUser: Bool

    var iconName = "questionmark"
    /*
    private var iconName: String {
        if let initial = message.senderId//message.senderName.first{
            //return initial.lowercased()
        } else {
            return "questionmark"
        }
    }
     */

    private var iconColor: Color {
        if isCurrentUser {
            return .purple
        } else {
            return .green
        }
    }
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    
    var body: some View {
        if (sessionManager.databaseManager.currentUser?.id == message.receiverId) {
            ZStack{
                let receiverUser = sessionManager.databaseManager.getUserProfile(userID: message.receiverId)
                let initial = receiverUser?.username.first
                CusColor.backcolor.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading)  {
                HStack(alignment: .top) {
                    Image(systemName: "\(initial ?? "?").circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)

                    //Image(systemName: "\(iconName).circle.fill")
                      //  .font(.largeTitle)
                        //.foregroundColor(.blue)

                    VStack(alignment: .leading) {
                        //MARK: To be deleted when page is final
                        /*Text("From: \((sessionManager.databaseManager.getUserProfile(userID: message.senderId))?.username ?? "ERROR")")
                            .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            .foregroundColor(Color("primaryColor"))
                        //MARK: Time displays work, we just have to format it since it shows seconds since epoch
                        //Text("Time: \(message.creationDate)")
                            //.font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            //.foregroundColor(Color("primaryColor"))
                        Text("To: \((sessionManager.databaseManager.getUserProfile(userID: message.receiverId))?.username ?? "ERROR")")
                            .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            .foregroundColor(Color("primaryColor"))
                        //Text("Current User: \(sessionManager.databaseManager.currentUser?.username ?? "Error: User not found")")
                        //    .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                        //    .foregroundColor(Color("primaryColor"))
                        */
                        Text(message.body)
                            .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            .foregroundColor(Color("primaryColor"))
                            .padding(.trailing, 50)
                        
                        }
                }
                .padding(.horizontal, 16)

                Divider().padding(.leading, 16)
            }
            .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        }
    } else {
            ZStack{
                CusColor.backcolor.edgesIgnoringSafeArea(.all)
                VStack(alignment: .trailing)  {
                HStack(alignment: .top) {
                    //Image(systemName: "\(iconName).circle.fill")
                      //  .font(.largeTitle)
                        //.foregroundColor(.blue)

                    VStack(alignment: .leading) {
                        //MARK: To be deleted when page is final
                        /*Text("From: \((sessionManager.databaseManager.getUserProfile(userID: message.senderId))?.username ?? "ERROR")")
                            .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            .foregroundColor(Color("primaryColor"))
                        //MARK: Time displays work, we just have to format it since it shows seconds since epoch
                        //Text("Time: \(message.creationDate)")
                            //.font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            //.foregroundColor(Color("primaryColor"))
                        Text("To: \((sessionManager.databaseManager.getUserProfile(userID: message.receiverId))?.username ?? "ERROR")")
                            .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            .foregroundColor(Color("primaryColor"))
                        //Text("Current User: \(sessionManager.databaseManager.currentUser?.username ?? "Error: User not found")")
                        //    .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                        //    .foregroundColor(Color("primaryColor"))
                        */
                        Text(message.body)
                            .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                            .foregroundColor(Color("primaryColor"))
                            .padding(.leading, 50)
                        
                        }
                    
                    let initial = sessionManager.databaseManager.currentUser?.username.first
                        Image(systemName: "\(initial ?? "?").circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    
                }
                .padding(.horizontal, 16)

                Divider().padding(.leading, 16)
            }
            .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        }
    }
}
}
/*
struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        MessageRow(message: Message(
            senderId: "fabricio",
            receiverId: "receiver",
            body: "hello, corre!",
            creationDate: 0
            ),
            isCurrentUser: true
        )
    }
}
*/
