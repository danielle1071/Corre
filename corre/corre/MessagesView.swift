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
    //@ObservedObject var sessionManager = SessionManger()
    //same ad MessageRow, if sessionManager is not an Environment Object, it will fail to send the username in the message
    
    init() {
        messageManager.getMessages()
        messageManager.observeMessages()
        
    }
    
    var body: some View {
        VStack {
            Button("Back", action: sessionManager.showSession)
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(messageManager.messages) {  message in
                            MessageRow(
                                message: message,
                                isCurrentUser: message.senderId == sessionManager.databaseManager.currentUser?.username ?? "User not, found"
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
