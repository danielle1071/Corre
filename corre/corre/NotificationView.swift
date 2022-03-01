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
            }.onTapGesture(perform: {
                print("Tapped A Notification")

            })
        }
    }
    
    struct NotificationRow: View {

            var notification: Notification

            var body: some View {
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
            }
        }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
