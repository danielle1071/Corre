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
                .font(.custom("Varela Round Regular", size: 21))
                .foregroundColor(CustomColor.primarycolor)
                .padding([.bottom], 5)
                
            
            TextField("Confirmation Code", text:
                        $confirmationCode)
                .keyboardType(.decimalPad)
                .frame(width: 320, height: 50)
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .padding([.horizontal], 10)
                .background(.white)
                .cornerRadius(15)
                .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("textLight"), lineWidth: 0.8)
                )
                .padding([.bottom], 8)
            Button("Confirm", action: {
                sessionManager.confirm(
                    username: username,
                    code: confirmationCode
                )
            })
                .padding()
                .foregroundColor(.white)
                .padding(.horizontal, 122)
                .background(CustomColor.primarycolor)
                .cornerRadius(20)
                .font(.custom("Proxima Nova Rg Regular", size: 18))
            
            Button("Didn't get it? Retry", action: {
                    Amplify.Auth.resendSignUpCode(for: username)
                    })
            .padding()
            .font(.custom("Proxima Nova Rg Regular", size: 18))
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
