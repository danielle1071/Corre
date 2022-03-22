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
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    sessionManager.showFriendView()
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
                    .foregroundColor(Color("primaryColor"))
                }
                .padding(.all)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
                        
            Text("Sent Friend Requests")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            List(requests, id: \.id) {
                request in
                SentFriendRequestRow(req: request)
            }
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
    struct SentFriendRequestRow: View {
        @EnvironmentObject var sessionManager: SessionManger
        var req: Notification
        var body: some View {
            Text("Username: \(sessionManager.databaseManager.getUserProfile(userID: req.receiverId)?.username ?? "NOT")")
            Button("Cancel", action: {
                sessionManager.databaseManager.deleteNotificationRecord(notification: req)
                sessionManager.showFriendView()
            })
        }
    }
}

//struct SentFriendReqView_Previews: PreviewProvider {
//    static var previews: some View {
//        SentFriendReqView()
//    }
//}
