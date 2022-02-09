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



struct ExampleSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = "" 
    @State var ecEmail = ""
    @State var ecPhone = ""
        
    var body: some View {
        VStack {
            
            Text("Add your first emergency contact to start running safely!")
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(CustomColor.primarycolor)
                .opacity(0.5)
                .padding([.horizontal], 25)
            
            Group {
                TextField("First Name", text: $ecFirst)
                TextField("Last Name", text: $ecLast)
                TextField("E-mail", text: $ecEmail)
                TextField("Phone Number", text: $ecPhone)
            }
                .padding(15)
                .padding([.horizontal], 25)
                

                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .padding([.horizontal], 25)
                )
            

            
            
            Button("Dismiss", action: close)
                .font(.custom("Proxima Nova Rg Regular", size: 20))
            
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

struct SessionView: View {
    
    
    @EnvironmentObject var sessionManager: SessionManger
    @State private var showingSheet = false
    
    let user: AuthUser
    
    var body: some View {
        VStack {
        
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
            
            Button("Show Sheet") {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet, content: ExampleSheet.init)
                    .padding()
                        .padding(.horizontal, 50)
                        .foregroundColor(CustomColor.primarycolor)
                        
            
            Button("Emergency Contacts", action: {
                sessionManager.showEmergencyContact()
            }).padding()
                .padding(.horizontal, 50)
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
        }
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
