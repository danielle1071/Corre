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
    
    let user: AuthUser
    
    var body: some View {
        VStack {
        
//            Text("WooHoo! You have signed in to the up-and-coming Corre Application! 🤯")
//                .font(.title2)
//                .multilineTextAlignment(.center)
            
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
