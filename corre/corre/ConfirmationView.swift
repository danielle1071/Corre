//
//  ConfirmationView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

import Foundation
import SwiftUI
import Amplify
import Combine

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State var confirmationCode = ""
    
    let username: String
    
    var body: some View {
        VStack {
            Text("Username: \(username)")
            TextField("Confirmation Code", text:
                        $confirmationCode)
            Button("Confirm", action: {
                sessionManager.confirm(
                    username: username,
                    code: confirmationCode
                )
            })
            .padding()
            Button("Resend code", action: {
                    Amplify.Auth.resendSignUpCode(for: username)
                    })
            .padding()
            }
        }
    
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "Corre Database Developer!")
        
    }
}
