//
//  ConfirmEmailView.swift
//  corre
//
//  Created by Fabricio Battaglia on 3/22/22.
//

import Foundation
import SwiftUI

struct ConfirmEmailView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State var email = ""
    
    var body: some View {
        VStack {
            TextField("email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .cornerRadius(16)
                .shadow(radius: 2.0)
                .padding([.horizontal], 20)
            
            Spacer()
            
            Button("Send code", action:{
                sessionManager.databaseManager.resetPassword(email: email)
                sessionManager.showConfirmPassResetView(email: email)
            })
            
            Spacer()
            
            Button("Cancel", action:{
                sessionManager.showLogin()
            })
        }
    }
}
