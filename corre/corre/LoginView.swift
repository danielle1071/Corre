//
//  LoginView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State var login = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Username", text: $login)
            SecureField("Password", text: $password)
            Button("Login", action: {
                sessionManager.login(
                    username: login,
                    password: password
                )
            })
            
            Spacer()
            Button("Not a user yet?, sign up!", action:
                    sessionManager.showSignUp)
        }
        .padding()
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
