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

            
            List(){
                ForEach(sessionManager.databaseManager.notifications, id: \.id) {
                notification in
                NotificationRow(notification: notification)
                }
                .onDelete(perform: delete)
            }
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            sessionManager.connect.sendStateUpdate()
        })
    }
    
    func delete(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let notification = sessionManager.databaseManager.notifications[index]
            print("This is the notification to delete \(notification)")
            sessionManager.databaseManager.deleteNotificationRecord(notification: notification)
        }
        
        Task() {
            do {
                try await sessionManager.databaseManager.getNotifications()
                DispatchQueue.main.async {
                    self.sessionManager.showNotificationView()
                }
            } catch {
                print("ERROR")
            }
        }
        
//        contacts = sessionManager.databaseManager.emergencyContacts
    }
    
    struct NotificationRow: View {
        var DEBUG = true

        var notification: Notification
        @EnvironmentObject var sessionManager: SessionManger

            var body: some View {

                    VStack {
                        
                        switch notification.type {
                        case .friendrequest:
                            HStack{
                                Text("Friend Request")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button("Accept", action: {
                                    if notification.type == NotificationType.friendrequest {
                                        print("Accept Friend Req")
                                        sessionManager.databaseManager.acceptedFriendRequest(notification: notification, userId: notification.senderId)
                                    } else if notification.type == NotificationType.emergencycontactrequest {
                                        print("Accept Emergency Contact")
                                        print("Notification *** \(notification)")
                                        sessionManager.databaseManager.acceptEmergencyContactRequest(notification: notification)
                                    }
                                    Task() {
                                        do {
                                            try await sessionManager.databaseManager.getNotifications()
                                            DispatchQueue.main.async {
                                                self.sessionManager.showNotificationView()
                                            }
                                        } catch {
                                            print("ERROR")
                                        }
                                    }
                                })
                            }
                        case .emergencycontactrequest:
                            HStack{
                                Text("Emergency Contact Request")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button("Accept", action: {
                                    if notification.type == NotificationType.friendrequest {
                                        print("Accept Friend Req")
                                        sessionManager.databaseManager.acceptedFriendRequest(notification: notification, userId: notification.senderId)
                                    } else if notification.type == NotificationType.emergencycontactrequest {
                                        print("Accept Emergency Contact")
                                        print("Notification *** \(notification)")
                                        sessionManager.databaseManager.acceptEmergencyContactRequest(notification: notification)
                                    }
                                    Task() {
                                        do {
                                            try await sessionManager.databaseManager.getNotifications()
                                            DispatchQueue.main.async {
                                                self.sessionManager.showNotificationView()
                                            }
                                        } catch {
                                            print("ERROR")
                                        }
                                    }
                                })
                            }
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
                        let user = sessionManager.databaseManager.getUserProfile(userID: notification.senderId)
                        Text("User: \(user?.username ?? notification.senderId)")
                            .font(.custom("Proxima Nova Rg Regular", size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
            }
        }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
