//
//  LoginView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

// import Foundation
import SwiftUI

struct CustomColor {
    static let backcolor =
        Color("backgroundColor")
    
    static let primarycolor = Color("primaryColor")
}

struct LoginView: View {
    
    
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State var login = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 200.0, height: 200.0)
                .scaledToFit()
            
            Spacer()
                .frame(height: 50)
            
            Text("Welcome Back")
                .font(.system(size: 36.0))
                .foregroundColor(CustomColor.primarycolor)
            
            Spacer()
                .frame(height: 25)
                
            
            TextField("Username", text: $login)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .padding([.horizontal], 20)
                .cornerRadius(16)
                .shadow(radius: 2.0)
    
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .padding([.horizontal], 20)
                .cornerRadius(16)
                .shadow(radius: 2.0)
                
            
            Spacer()
                .frame(height: 25)
            Button("Login", action: {
                sessionManager.login(
                    username: login,
                    password: password
                )
            }).padding()
                .foregroundColor(.white)
                .padding(.horizontal, 100)
                .background(CustomColor.primarycolor)
                .cornerRadius(20)
                
            
            Spacer()
            Button("Don't have an account? Sign up", action:{
                
                sessionManager.showSignUp()
                })
                    
        } .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
