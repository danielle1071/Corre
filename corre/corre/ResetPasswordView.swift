//
//  ResetPasswordView.swift
//  corre
//
//  Created by Fabricio Battaglia on 3/22/22.
//

import Foundation
import SwiftUI

struct ResetPasswordView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State var code = ""
    @State var password = ""
    @State var invalidAttempts = 0
    var email: String
    
    var body: some View {
        VStack {
            TextField("Confirmation Code", text: $code)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .cornerRadius(16)
                .shadow(radius: 2.0)
                .padding([.horizontal], 20)
            

            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .cornerRadius(16)
                .shadow(radius: 2.0)
                .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundColor(invalidAttempts == 0 ? Color.clear : Color.red))
                .padding([.horizontal], 20)
            
            Spacer()
            
            Button("Confirm new password", action:{
                sessionManager.databaseManager.confirmResetPassword(email: email, newPassword: password, confirmationCode: code)
                sessionManager.showLogin()
            })
            
            Spacer()
            
            Button("Re-send code", action:{
                sessionManager.databaseManager.resetPassword(email: email)
            })
            
            Spacer()
            
            Button("Cancel", action:{
                sessionManager.showLogin()
            })
        }
    }
}
