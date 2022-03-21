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
            HStack{
                Button(action: {
                    sessionManager.showNavBar()
                }, label: {
                    Image(systemName: "arrow.left")
                        .renderingMode(.original)
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(Color("primaryColor"))
                    Text("Back")
                        .foregroundColor(Color("primaryColor"))
                })
                Spacer()
                .foregroundColor(Color("primaryColor"))
                
                
                Button(action: {
                    sessionManager.showNotificationView()
                }, label: {
                    Text("Refresh")
                        .foregroundColor(Color("primaryColor"))
                })
                
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
//            Button("Back") {
//                sessionManager.showSession()
//            }
//            Text("Notifications")
            
            Image("CreamLogo")
            .resizable()
            .frame(width: 125.0, height: 125.0)
            .scaledToFit()
            
            Text("Notifications")
                .multilineTextAlignment(.center)

            
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

                    VStack {
                        
                        switch notification.type {
                        case .friendrequest:
                            Text("Friend Request")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .emergencycontactrequest:
                            Text("Emergency Contact Reqeust")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .message:
                            Text("Message")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .runnerstarted:
                            Text("Run Started By Sender")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .none:
                            Text("No Type Listed")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text("Sender: \(notification.senderId)")
                            .font(.custom("Proxima Nova Rg Regular", size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
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
            }
        }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
