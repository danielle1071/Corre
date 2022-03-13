//
//  NotificationView.swift
//  corre
//
//  Created by Lucas Morehouse on 2/26/22.
//

import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    var body: some View {
        VStack {
            Button("Back") {
                sessionManager.showSession()
            }
            Text("Notifications")
            List(sessionManager.databaseManager.notifications, id: \.id) {
                notification in
                NotificationRow(notification: notification)
            }
        }
    }
    
    struct NotificationRow: View {

        var notification: Notification
        @EnvironmentObject var sessionManager: SessionManger

            var body: some View {
//                HStack {
                    VStack {
                        switch notification.type {
                        case .friendrequest:
                            Text("Friend Request!")
                        case .emergencycontactrequest:
                            Text("Emergency Contact Reqeust")
                        case .message:
                            Text("Message!")
                        case .runnerstarted:
                            Text("Run Started By Sender")
                        case .none:
                            Text("No Type Listed")
                        }
                        Text("Sender: \(notification.senderId)")
                    }
                if notification.type == .friendrequest || notification.type == .emergencycontactrequest {
                
                    Button("Accept", action: {
                        print("Accept")
                        sessionManager.databaseManager.acceptedFriendRequest(notification: notification, userId: notification.senderId)
                    })
                    Button("Decline", action: {
                        print("Decline")
                    })
                }
                
//                }
                
            }
        }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
