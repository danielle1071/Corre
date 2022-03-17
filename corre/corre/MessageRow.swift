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

    let iconName = "questionmark"
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
        ZStack{
            CusColor.backcolor.edgesIgnoringSafeArea(.all)
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "\(iconName).circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text("\((sessionManager.databaseManager.getUserProfile(userID: message.senderId))?.username ?? "ERROR")")
                        .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                        .foregroundColor(Color("primaryColor"))
                    Text("\(sessionManager.databaseManager.currentUser?.username ?? "Error: User not found")")
                        .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                        .foregroundColor(Color("primaryColor"))

                    Text(message.body)
                        .font(Font.custom("Proxima Nova Rg Regular", size: 15))
                        .foregroundColor(Color("primaryColor"))
                        
                }
            }
            .padding(.horizontal, 16)

            Divider().padding(.leading, 16)
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
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
