//
//  SessionView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

import Foundation
import SwiftUI
import Amplify


struct SessionView: View {
    
    
    @EnvironmentObject var sessionManager: SessionManger

    @State private var showingSheet = false
    

    @State var userId = "C8BC189F-E05F-4F80-9507-5B3A556C4330"


    // @State var userId = "C8BC189F-E05F-4F80-9507-5B3A556C4330"

    let user: AuthUser
    
    var body: some View {
        VStack {
        

            // Text("WooHoo! You have signed in to the up-and-coming Corre Application! 🤯")
            //    .font(.title2)
            //    .multilineTextAlignment(.center)
            
            
            // MARK: NEED TO UPDATE THE USER TRACKING ID --- CURRENTLY HARD CODED FOR TESTING!
            Button("TrackRunner", action: {sessionManager.showTrack(userTrackingID: userId)})
            
            

            Spacer()
            Button("Run", action: {
                sessionManager.showRunning()
            }).padding()
                .padding(.horizontal, 108)
                .foregroundColor(CustomColor.primarycolor)
                .background(CustomColor.backcolor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                    .stroke(CustomColor.primarycolor, lineWidth: 2)
                )
            
            
            Spacer()
            Button("Profile", action: {
                sessionManager.showProfile()
            }).padding()
                .padding(.horizontal, 108)
                .foregroundColor(CustomColor.primarycolor)
                .background(CustomColor.backcolor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                    .stroke(CustomColor.primarycolor, lineWidth: 2)
                )
            
            Spacer()
            
//            Button("Show Sheet") {
//                        showingSheet.toggle()
//                    }
//                    .sheet(isPresented: $showingSheet, content: ExampleSheet.init)
//                    .padding()
//                        .padding(.horizontal, 50)
//                        .foregroundColor(CustomColor.primarycolor)
//
            
//            Button("Emergency Contacts", action: {
//                sessionManager.showEmergencyContact()
//            }).padding()
//                .padding(.horizontal, 50)
//                .foregroundColor(CustomColor.primarycolor)
//                .background(CustomColor.backcolor)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                    .stroke(CustomColor.primarycolor, lineWidth: 2)
//                )
            
            Button("Emergency Contacts") {
                showingSheet.toggle()
            }
                .sheet(isPresented: $showingSheet, content: ExampleSheet.init)
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
            
    

    
            Spacer()
            Button("Sign Out", action: {
                sessionManager.signOut()
            }).padding()
                .padding(.horizontal, 100)
                .foregroundColor(CustomColor.primarycolor)
                .background(CustomColor.backcolor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                    .stroke(CustomColor.primarycolor, lineWidth: 2)
                )
            
    
            Spacer()
        }.onAppear(perform: {
            sessionManager.databaseManager.createDeviceRecord()
        })
        
    }
    
}

struct ExampleSheet: View {
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
                            TextField("E-mail", text: $ecEmail)
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
    
    private struct TestUser: AuthUser {
        let userId: String = "1"
        let username: String = "Test"
    }
    static var previews: some View {
        SessionView(user: TestUser())
    }
     
    
}
