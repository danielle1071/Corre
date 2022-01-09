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
    // let user: AuthUser
    
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
            Button("[WORK IN PROGRESS] Resend code", action: {
                print("This button is broken")
                // sessionManager.resendCode()
             })
        }
        .padding()
    }
    // This function was taken from https://docs.amplify.aws/lib/auth/user-attributes/q/platform/ios/#resend-verification-code
    
    
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "Corre Database Developer!")
    }
}
