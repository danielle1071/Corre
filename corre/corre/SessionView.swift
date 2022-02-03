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
            Spacer()
            Text("WooHoo! You have signed in to the up-and-coming Corre Application! 🤯")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Spacer()
            Button("Sign Out", action: {
                sessionManager.signOut()
                
            })
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
