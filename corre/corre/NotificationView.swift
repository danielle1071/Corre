//
//  NotificationView.swift
//  corre
//
//  Created by Lucas Morehouse on 2/26/22.
//

import SwiftUI

struct NotificationView: View {
    var DEBUG = true
    
    @EnvironmentObject var sessionManager: SessionManger

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
                    sessionManager.showNavBar()
                }, label: {
                    Image(systemName: "arrow.left")
                        .renderingMode(.original)
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(Color("primaryColor"))
                    Text("Back")
                        .font(.custom("Varela Round Regular", size: 18))
                        .foregroundColor(Color("primaryColor"))
                })
                Spacer()
                .foregroundColor(Color("primaryColor"))
                
                
                Button(action: {
                    sessionManager.showNotificationView()
                }, label: {
                    Text("Refresh")
                        .font(.custom("Varela Round Regular", size: 18))
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
                .shadow(radius: 2)
            
            Text("Notifications")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            
            List(sessionManager.databaseManager.notifications, id: \.id) {
                notification in
                NotificationRow(notification: notification)
            }
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
    struct NotificationRow: View {
        var DEBUG = true

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
                            Text("Emergency Contact Request")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .message:
                            Text("Message")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .runnerstarted:
                            Text("Run Event Started")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .runnerended:
                            Text("Run Event Ended")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .runevent:
                            Text("This is a generic runevent type")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .other:
                            Text("This is a catch all notification type")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .none:
                            Text("No Type Listed")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text("User: \(notification.senderId)")
                            .font(.custom("Proxima Nova Rg Regular", size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                
                if (notification.type == .runevent) {
                    Button("Remove", action: {
                        if (DEBUG) { print("NotificationView -> .runevent -> Remove \(notification)") }
                        
                        sessionManager.databaseManager.deleteNotificationRecord(notification: notification)
                    })
                }
                    
                if (notification.type == .runnerstarted) {
                    Button("Remove", action: {
                        if (DEBUG) { print("NotificationView -> .runnerstarted -> Remove \(notification)") }
                        
                        sessionManager.databaseManager.deleteNotificationRecord(notification: notification)
                    })
                }
                
                if (notification.type == .runnerended) {
                    Button("Remove", action: {
                        if (DEBUG) { print("NotificationView -> .runnerend -> Remove \(notification)") }
                        
                        sessionManager.databaseManager.deleteNotificationRecord(notification: notification)
                    })
                }
                    
                if notification.type == .friendrequest || notification.type == .emergencycontactrequest {
                    
                    
                    Button("Accept", action: {
                        if notification.type == NotificationType.friendrequest {
                            print("Accept Friend Req")
                            sessionManager.databaseManager.acceptedFriendRequest(notification: notification, userId: notification.senderId)
                        } else if notification.type == NotificationType.emergencycontactrequest {
                            print("Accept Emergency Contact")
                            print("Notification *** \(notification)")
                            sessionManager.databaseManager.acceptEmergencyContactRequest(notification: notification)
                        }
                    })
                        
                    Button("Decline", action: {
                        print("Decline")
                        sessionManager.databaseManager.deleteNotificationRecord(notification: notification)
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
