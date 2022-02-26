//
//  MessagesView.swift
//  corre
//
//  Created by Fabricio Battaglia on 2/18/22.
//

import SwiftUI
import Foundation
import Amplify

struct MessagesView: View {

    @State var text = String()
    @ObservedObject var messageManager = MessageManager()
    @EnvironmentObject var sessionManager: SessionManger

    

    //let currentUser = Amplify.Auth.getCurrentUser()//"fabricio"//get username or user id
    //now I have to get the user from database using authID
    
    //lazy var userDbId = messageManager.getUserInfo(sender: currentUser!)
    //lazy var userDb = sessionManager.databaseManager.getUserProfile(userID: userDbId)
    //lazy var username = userDb!.username

    

    
    init() {
        messageManager.getMessages()
        messageManager.observeMessages()
        
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(messageManager.messages) {  message in
                        MessageRow(
                            message: message,
                            isCurrentUser: message.senderId == sessionManager.databaseManager.currentUser?.username ?? "User not, found"
                            /*
                            senderUsername: message.senderId
                             */
                        )
                    }
                }
            }

            HStack {
                TextField("Enter message", text: $text)
                Button("Send", action: didTapSend)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.purple)
            }
        }
        .padding(.horizontal, 16)
    }

    func didTapSend() {
        print(text)

        let message = Message(
            senderId: sessionManager.databaseManager.currentUser?.id ?? "000", receiverId: sessionManager.databaseManager.currentUser?.id ?? "000", body: text, creationDate: Int(Date().timeIntervalSince1970)
        )
        messageManager.send(message)

        text.removeAll()
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
