//
//  ConfirmationView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  Edited by Lauren Wright on 1/26/2022
//  Added UI
//  Changed on 1/31/22 by LW
//
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
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 250.0, height: 250.0)
                .scaledToFit()
            

            Text("Username: \(username)")
                .font(.system(size: 23.0))
                .foregroundColor(CustomColor.primarycolor)
            
            TextField("Confirmation Code", text:
                        $confirmationCode)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .padding([.horizontal], 20)
                .cornerRadius(16)
                .shadow(radius: 2.0)
                .padding()
            Button("Confirm", action: {
                sessionManager.confirm(
                    username: username,
                    code: confirmationCode
                )
            })
                .padding()
                .foregroundColor(.white)
                .padding(.horizontal, 100)
                .background(CustomColor.primarycolor)
                .cornerRadius(20)
            
            Button("Didn't get it? Retry", action: {
                    Amplify.Auth.resendSignUpCode(for: username)
                    })
            .padding()
            }

            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
            
        }
    
}


struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "Database Developer")
        
    }
}
