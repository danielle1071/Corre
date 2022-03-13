//
//  SentFriendReqView.swift
//  corre
//
//  Created by Lucas Morehouse on 3/13/22.
//

import SwiftUI

struct SentFriendReqView: View {
    @EnvironmentObject var sessionManager: SessionManger
    var requests: [Notification]
    
    var body: some View {
        Button("Back") {
            sessionManager.showSession()
        }
        List(requests, id: \.id) {
            request in
            SentFriendRequestRow(req: request)
        }
    }
    
    struct SentFriendRequestRow: View {
        @EnvironmentObject var sessionManager: SessionManger
        var req: Notification
        var body: some View {
            Text("Username: \(sessionManager.databaseManager.getUserProfile(userID: req.receiverId)?.username ?? "NOT")")
            Button("Cancel", action: {
                sessionManager.databaseManager.deleteNotificationRecord(notification: req)
            })
        }
    }
}

//struct SentFriendReqView_Previews: PreviewProvider {
//    static var previews: some View {
//        SentFriendReqView()
//    }
//}
