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
            HStack{
                Button(action: {
                    sessionManager.showSession()
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
                
            }
            .padding(.all)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
            
            Text("Track Contacts")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            
            // Text("🏃🏼‍♀️")
            // Text("🧍🏼‍♀️")
            
            List(sessionManager.databaseManager.runners, id: \.id) {
                item in
                RunnerRow(emergencyContact: item)
                    .onTapGesture(perform: {
                        print("This is the item: \(item)")
                        let runCheck = sessionManager.databaseManager.checkIfRunning(userID: item.userID)
                        if runCheck {
                            sessionManager.showTrack(userTrackingID: item.userID)
                        } else {
                            
                            // MARK: user currently not running!
                            sessionManager.showTrackContacts()
                        }
                    })
            }
            .font(.custom("Proxima Nova Rg Regular", size: 18))
            
//            Button(action: {
//                    sessionManager.showSession()
//
//                }, label: {
//                    Text("Back")
//                    .fontWeight(.bold)
//                    .frame(width: 100.0, height: 40.0)
//                    .foregroundColor(Color.white)
//                    .background(CusColor.primarycolor)
//                    .clipShape(Capsule())
//            })
            
            // MARK: deleteThis - this is temporary
//            VStack {
//                Group {
//                    Spacer()
//                        .frame(height: 30)
//
//                    TextField("User ID", text: $userId)
//                }
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(height: 40)
//                    .padding([.horizontal], 20)
//                    .cornerRadius(16)
//                    .shadow(radius: 2.0)
//
//                Button(action: {
//                        sessionManager.showTrack(userTrackingID: userId)
//                    }, label: {
//                        Text("Track Runner")
//                        .fontWeight(.bold)
//                        .frame(width: 150.0, height: 40.0)
//                        .foregroundColor(Color.white)
//                        .background(CusColor.primarycolor)
//                        .clipShape(Capsule())
//                })
//            }
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        
    }
    
    struct RunnerRow: View {
        @EnvironmentObject var sessionManager: SessionManger
        var emergencyContact: EmergencyContact
        
        var body: some View {
            HStack{
                Text("\(sessionManager.databaseManager.getUserProfile(userID: emergencyContact.userID)?.username ?? "ERROR") ")
                let runCheck = sessionManager.databaseManager.checkIfRunning(userID: emergencyContact.userID)
                if runCheck {
                    Text("🏃‍♂️")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    Text("🧍‍♂️")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
    
    struct TrackContentView_Previews: PreviewProvider {
        static var previews: some View {
            TrackContactsView()
        }
    }
}
