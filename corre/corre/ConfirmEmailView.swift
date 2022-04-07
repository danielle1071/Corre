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
            
            Group {
                Text("Forgot your password?")
                    .font(.custom("Varela Round Regular", size: 40))
                    .foregroundColor(Color("primaryColor"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.bottom], 2)
                    .multilineTextAlignment(.center)
                
                Text("Enter your e-mail and we'll")
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .foregroundColor(Color("lightGray"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.top], 10)
    //                .padding([.top], gWidth * -0.06)
    //                .padding([.bottom], gWidth * 0.03)
                
                Text("send you a reset code.")
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .foregroundColor(Color("lightGray"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.bottom], 10)
                    .padding([.top], 0)
                
                Image("forgotPassword")
                    .resizable()
                    .frame(width: 200.0, height: 160.0)
                    .padding([.top], 20)
                    .padding([.bottom], 20)
            }
           
            TextField("E-mail", text: $email)
                .frame(width: 320, height: 50)
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .padding([.horizontal], 10)
                .background(.white)
                .cornerRadius(15)
                .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("textLight"), lineWidth: 0.8)
                )
    
            
    
            
            Button("**Send**", action:{
                if(email != ""){
                    sessionManager.databaseManager.resetPassword(email: email)
                    sessionManager.showConfirmPassResetView(email: email)
                } else {
                    //MARK: Front end: display error "Email can't be empty"
                }
            })
            .padding([.horizontal], 147)
            .padding([.vertical],15)
            .foregroundColor(Color.white)
            .background(Color("primaryColor"))
            .cornerRadius(14)
            .padding([.top], 10)
            .font(.custom("Proxima Nova Rg Regular", size: 20))
            
            
            
            
            Spacer()
            Divider()
            Button("Back to Login", action:{
                sessionManager.showLogin()
            })
            .padding([.top], 5)
            .font(.custom("Proxima Nova Rg Regular", size: 18))
        }
        .padding([.top], 40)
        .padding()
        .background(Color("backgroundColor"))
    }
}

struct ConfirmEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmEmailView()
    }
}
