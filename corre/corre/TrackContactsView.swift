//
//  TrackContactsView.swift
//  corre
//
//  Created by Jon Abrigo on 2/16/22.
//
//  Updated by Lucas Morehouse on 2/26/22.

import SwiftUI
import Foundation
import Amplify
import Combine

struct TrackContactsView: View {
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }
    
    @EnvironmentObject var sessionManager: SessionManger
    
    // MARK: deleteThis - this is temporary
    @State var userId = ""
    
    var body: some View {
        VStack {
            List(sessionManager.databaseManager.runners, id: \.id) {
                item in
                RunnerRow(emergencyContact: item)
                    .onTapGesture(perform: {
                        print("This is the item: \(item)")
                        let runCheck = sessionManager.databaseManager.checkIfRunning(userID: item.userID)
                        if runCheck {
                            sessionManager.showTrack(userTrackingID: item.userID)
                        } else {
                            sessionManager.showSession()
                        }
                    })
            }
            
            Button(action: {
                    sessionManager.showSession()
                }, label: {
                    Text("Back")
                    .fontWeight(.bold)
                    .frame(width: 100.0, height: 40.0)
                    .foregroundColor(Color.white)
                    .background(CusColor.primarycolor)
                    .clipShape(Capsule())
            })
            
            // MARK: deleteThis - this is temporary
            VStack {
                Group {
                    Spacer()
                        .frame(height: 30)
                    
                    TextField("User ID", text: $userId)
                }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .padding([.horizontal], 20)
                    .cornerRadius(16)
                    .shadow(radius: 2.0)
                
                Button(action: {
                        sessionManager.showTrack(userTrackingID: userId)
                    }, label: {
                        Text("Track Runner")
                        .fontWeight(.bold)
                        .frame(width: 150.0, height: 40.0)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(Capsule())
                })
            }

        }
        
    }
    
    struct RunnerRow: View {
        @EnvironmentObject var sessionManager: SessionManger
        var emergencyContact: EmergencyContact
        
        var body: some View {
            
            Text("\(sessionManager.databaseManager.getUserProfile(userID: emergencyContact.userID)?.username ?? "ERROR") ")
        }
    }
    
    struct TrackContentView_Previews: PreviewProvider {
        static var previews: some View {
            TrackContactsView()
        }
    }
}
