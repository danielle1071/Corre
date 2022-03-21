//
//  SessionView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//
//  Modified by Mariana Botero on 02/07/2021
//  Modified by Mariana Botero on 03/01/2021

import Foundation
import SwiftUI
import Amplify


struct SessionView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State private var showingSheet = false
//    @State var userId = "C8BC189F-E05F-4F80-9507-5B3A556C4330"
    
    // @State var userId = "C8BC189F-E05F-4F80-9507-5B3A556C4330"
    let user: AuthUser
    
    
    var body: some View {

        GeometryReader { geometry in

        
            // MARK: NEED TO UPDATE THE USER TRACKING ID --- CURRENTLY HARD CODED FOR TESTING!
//            Button("TrackRunner", action: {sessionManager.showTrack(userTrackingID: userId)})

            Spacer()
            Button("Run", action: {
                if sessionManager.databaseManager.emergencyContacts.isEmpty {
                    showingSheet.toggle()
                } else {
                    sessionManager.showPreRunning()
                }
            }).sheet(isPresented: $showingSheet, content: EmergencyPromptSheet.init)
                .padding()
                    .padding(.horizontal, 50)
                    .foregroundColor(CustomColor.primarycolor)
                .padding(.horizontal, 10)
                .foregroundColor(CustomColor.primarycolor)
                .background(CustomColor.backcolor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                    .stroke(CustomColor.primarycolor, lineWidth: 2)
                )
            
            
//            Spacer()
//            Button("Profile", action: {
//                sessionManager.showProfile()
//            }).padding()
//                .padding(.horizontal, 108)
//                .foregroundColor(CustomColor.primarycolor)
//                .background(CustomColor.backcolor)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                    .stroke(CustomColor.primarycolor, lineWidth: 2)
//                )
            
//            Spacer()

            
            let gWidth = geometry.size.width
            let gHeight = geometry.size.height
            
            ZStack{
                
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                SwiftUI.VStack {
                    HStack {
                       
                            // MARK: Header Name Line
                        Text("Hi \(sessionManager.databaseManager.currentUser?.username ?? "Name")")
                                .font(.custom("Varela Round Regular", size: 40))
                                .foregroundColor(Color("primaryColor"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            
                            HStack (spacing: (gWidth * 0.05)) {
                                
                                // MARK: Friends Button
                                
                                Button(action: {
                                    sessionManager.showFriendView()
                                }) {
                                    Image("friends")
                                        .resizable()
                                        .frame(width: gWidth * 0.08, height: gWidth * 0.09)
                                }
                                
                                // MARK: Notifications Button
                                Button(action: {
                                    sessionManager.showNotificationView()
                                }) {
                                    Image("notifications")
                                        .resizable()
                                        .frame(width: gWidth * 0.08, height: gWidth * 0.08)
                                }
                                
                                // MARK: Settings Button
                                Button(action: {
                                    sessionManager.showProfile()
                                }) {
                                    Image("settings")
                                        .resizable()
                                        .frame(width: gWidth * 0.09, height: gWidth * 0.02)
                                }
                            }
                        

                        
                    }
                    
                    Text("Keep going. You can do it")
                        .font(.custom("Proxima Nova Rg Regular", size: 20))
                        .foregroundColor(Color("darkGray"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top], gWidth * -0.06)
                        .padding([.bottom], gWidth * 0.03)
                    
                    Image("header2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding([.bottom], 10)
                    
                    // MARK: Start Run Button
                    Button(action: {
                    if sessionManager.databaseManager.emergencyContacts.isEmpty {
                        showingSheet.toggle()
                    } else {
                        sessionManager.showPreRunning()
                    }
                })
                    {
                    Image("startRun")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    }
                    .sheet(isPresented: $showingSheet, content: EmergencyPromptSheet.init)
                   
    
                    // MARK: Track Runner Button
                    HStack (spacing: 20.0)
                    {
                        Button(action: {sessionManager.showTrackContacts()
                        })
                        {
                            Image("track")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                        // MARK: Emergency Contacts Button
                        
                        Button(action: {
                        if sessionManager.databaseManager.emergencyContacts.isEmpty {
                            showingSheet.toggle()
                        } else {
                            sessionManager.showEmergencyContact()
                        }
                        })
                        {
                            Image("contacts")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                            .sheet(isPresented: $showingSheet, content: EmergencyPromptSheet.init)
                         
                        
                    }
                    .padding([.top], 10)
                    
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)

            }
           
            
        }
    }
}
        

struct EmergencyPromptSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: SessionManger
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""

    var body: some View {

        GeometryReader { geometry in
            VStack {

            Text("Start running safely.")
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(CustomColor.primarycolor)
                .opacity(0.5)
                .padding([.horizontal], geometry.size.width * 0.09)
                .padding([.top], geometry.size.height * 0.32)
                .padding([.bottom], geometry.size.height * 0.02)

            VStack (alignment: .center) {
                Spacer()
                    .frame(height: geometry.size.height * 0.03)

                VStack (alignment: .center, spacing: 20){
                    Group {
                            TextField("First Name", text: $ecFirst)
                            TextField("Last Name", text: $ecLast)
                            TextField("E-mail or Username", text: $ecEmail)
                            TextField("Phone Number", text: $ecPhone)
                    }
                    .padding(geometry.size.height * 0.02)
                    .padding([.horizontal], geometry.size.width * 0.08)
                    .background(Color("backgroundColor"))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("lightGray"), lineWidth: 1)
                                .padding([.horizontal], geometry.size.width * 0.05)
                    )
                }

                Spacer()
                    .frame(height: geometry.size.height * 0.02)
                Button("Create", action: {


                    sessionManager
                        .databaseManager
                        .createEmergencyContactRecord(
                            firstName: ecFirst,
                            lastName: ecLast,
                            searchVal: ecEmail,
                            phoneNumber: ecPhone
                        )
                    sessionManager.showEmergencyContact()
                })
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .padding([.horizontal], geometry.size.width * 0.32)
                    .padding([.vertical], geometry.size.height * 0.02)
                    .foregroundColor(Color.white)
                    .background(Color("primaryColor"))
                    .cornerRadius(14)

                Spacer()
                    .frame(height: geometry.size.height * 0.03)

            }

                    .background(Color("backgroundColor"))
                    .cornerRadius(10)
                    .frame(width: geometry.size.width * 0.90,
                           height: geometry.size.height * 0.50)
                    .background(Color.gray
                                            .opacity(0.08)
                                            .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                            .blur(radius: 8, opaque: false)
                    )

                Spacer()
                    .frame(height: geometry.size.height * 0.04)

            Button("Dismiss", action: close)
                .font(.custom("Varela Round Regular", size: 20))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .interactiveDismissDisabled()
        .background(
            Image("newContactBackground")
                .scaledToFit()
        )
    }


    func close() {
        presentationMode.wrappedValue.dismiss()
    }
}


struct SessionView_Previews: PreviewProvider {
    @EnvironmentObject var sessionManager: SessionManger
    
    private struct TestUser: AuthUser {
        let userId: String = "1"
        let username: String = "Test"
    }
    static var previews: some View {
        SessionView(user: TestUser())
    }
    
}
