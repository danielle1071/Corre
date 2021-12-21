//
//  SignUpView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

import Foundation
import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State var username = ""
    @State var email = ""
    @State var phone = ""
    @State var password = ""
    
    var body: some View {
        VStack{
            Spacer()
            
            TextField("Username", text: $username)
            TextField("Email", text: $email)
            TextField("Phone Number", text: $phone)
            SecureField("Password", text: $password)
            Button("Sign Up", action: {
                sessionManager.signUp(
                    username: username,
                    email: email,
                    phone: phone,
                    password: password
                )
            })
            
            Spacer()
            Button("already a user? sign-in", action:
                    sessionManager.showLogin)
        }
        .padding()
    }
    
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
