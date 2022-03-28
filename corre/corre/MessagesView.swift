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

    @State var userId: String
    @State var text = String()
    @State var friendId: String
    @ObservedObject var messageManager = MessageManager()
    @EnvironmentObject var sessionManager: SessionManger
    //@ObservedObject var sessionManager = SessionManger()
    //same ad MessageRow, if sessionManager is not an Environment Object, it will fail to send the username in the message
    
    init(userId: String, friendId: String) {
        self.userId = userId
        self.friendId = friendId
        messageManager.setCurrentUserId(id: self.userId)
        messageManager.setCurrentFriendId(id: self.friendId)
        messageManager.getMessages()
        messageManager.observeMessages()
        
    }
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    var body: some View {
        VStack {
            HStack{
            Button("Back", action: sessionManager.showMessageFriendView)
                    .padding()
                    .foregroundColor(Color("primaryColor"))
                    .font(Font.custom("Proxima Nova Rg Regular", size: 18))
                Spacer()
            }
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
                    TextField("Enter message...", text: $text)
                        .font(Font.custom("Proxima Nova Rg Regular", size: 20))
                        .padding(15)
                        .padding([.horizontal], 25)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .padding([.horizontal], 25))
                    Button (action: didTapSend ){
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .foregroundColor(Color("primaryColor"))
                        .frame(width: 35.0, height: 35.0)
                        .scaledToFit()
                    }
                        .padding(.trailing, 20.0)
                        
                }
            }
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        //.padding(.horizontal, 16)
    }

    func didTapSend() {
        print(text)

        let message = Message(
            senderId: sessionManager.databaseManager.currentUser?.id ?? "000", receiverId: friendId, body: text, creationDate: Int(Date().timeIntervalSince1970)
        )
        messageManager.send(message)

        text.removeAll()
    }
}

/*struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}*/
