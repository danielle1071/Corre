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
    @State var reTypePassword = ""
    @State var invalidAttempts = 0
    var email: String
    
    var body: some View {
       
        
        VStack {
            
        Group {
            Text("Enter reset code")
                .font(.custom("Varela Round Regular", size: 40))
                .foregroundColor(Color("primaryColor"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.bottom], 2)
                .multilineTextAlignment(.center)
            
            Text("Enter your reset code")
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .foregroundColor(Color("lightGray"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.top], 10)
//                .padding([.top], gWidth * -0.06)
//                .padding([.bottom], gWidth * 0.03)
            
            Text("and new password.")
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .foregroundColor(Color("lightGray"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.bottom], 10)
                .padding([.top], 0)
            
            Image("checkEmail")
                .resizable()
                .frame(width: 230.0, height: 170.0)
                .padding([.top], 20)
                .padding([.bottom], 20)
            }
            
            
            Group {
                TextField("Verification Code", text: $code)
                    .frame(width: 320, height: 50)
                    .shadow(radius: 2.0)
                    .padding([.horizontal], 10)
                    .background(.white)
                    .cornerRadius(15)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("textLight"), lineWidth: 0.8)
                    )
                
                Group {
                    
                    SecureField("Password", text: $password)
                    .frame(width: 320, height: 50)
                        .shadow(radius: 2.0)
                        .padding([.horizontal], 10)
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("textLight"), lineWidth: 0.8)
                            .foregroundColor(invalidAttempts == 0 ? Color.clear : Color.red))
                        .padding([.horizontal], 20)
                        .padding([.top], 3)
                    SecureField("Confirm Password", text: $reTypePassword)
                        .frame(width: 320, height: 50)
                            .shadow(radius: 2.0)
                            .padding([.horizontal], 10)
                            .background(.white)
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("textLight"), lineWidth: 0.8)
                                .foregroundColor(invalidAttempts == 0 ? Color.clear : Color.red))
                            .padding([.horizontal], 20)
                            .padding([.top], 3)
                    
                    if password != "" {
                        if password == reTypePassword {
                            Text("password match")
                                .font(.system(size: 10.0))
                                .foregroundColor(Color.green)
                        } else {
                            Text("passwords do not match")
                                .font(.system(size: 10.0))
                                .foregroundColor(Color.red)
                        }
                    }
                   
            }
                
                
                Button("**Reset**", action:{
                    sessionManager.databaseManager.confirmResetPassword(email: email, newPassword: password, confirmationCode: code)
                    sessionManager.showLogin()
                })
//                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .padding([.horizontal], 147)
                .padding([.vertical],15)
                .foregroundColor(Color.white)
                .background(Color("primaryColor"))
                .cornerRadius(14)
                .padding([.top], 5)
                
                
                
            }
            HStack (spacing: 4){
                Text("Didn't get it?")
                Button("**Resend**", action:{
                    sessionManager.databaseManager.resetPassword(email: email)
                })
            }
            .padding([.top], 5)
            .padding([.bottom], 10)
          
            
            Spacer()
            
            Divider()
//                .padding([.top], 20)
//                .padding([.bottom], 20)
            
    
            
            Button("Back to Login", action:{
                sessionManager.showLogin()
            })
            .padding([.top], 5)
        }
        .padding([.top], 40)
        .padding()
        .background(Color("backgroundColor"))
    }
       
        
}
   

struct ResetPasswordView_Previews: PreviewProvider {
    
    @State static var email: String = "test@gmail.com"
    
    static var previews: some View {
        ResetPasswordView(email: email)
    }
}
