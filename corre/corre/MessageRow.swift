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
    @EnvironmentObject var sessionManager: SessionManger
    //let currentUser = Amplify.Auth.getCurrentUser()
    let message: Message
    let isCurrentUser: Bool
    //let senderUsername: String
    //let senderId: String
    //let curId: String
    
    //check if currentUser is sender
    /*
    init(sessionManager: SessionManger, message: Message, senderUsername: String, isCurrentUser: Bool){
        let curId = sessionManager.databaseManager.currentUser?.id
        let senderId = message.senderId
        if(senderId == curId) {
            self.isCurrentUser = true
        } else {
            self.isCurrentUser = false
            self.senderUsername = sessionManager.databaseManager.getUserProfile(userID: senderId)?.username ?? "Error: sender not found"
        }
    }
     */

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

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: "\(iconName).circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text("\((sessionManager.databaseManager.getUserProfile(userID: message.senderId))?.username ?? "ERROR")")
                    Text("\(sessionManager.databaseManager.currentUser?.username ?? "Error: User not found")") //\(senderUsername)
                        .font(.headline)

                    Text(message.body)
                        .font(.body)
                }
            }
            .padding(.horizontal, 16)

            Divider().padding(.leading, 16)
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
