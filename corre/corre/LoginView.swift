//
//  LoginView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  Edited by Lauren Wright on 1/24/2022
//  (Added frontend-UI)
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

// import Foundation
import SwiftUI

struct CustomColor {
    static let backcolor =
        Color("backgroundColor")
    
    static let primarycolor = Color("primaryColor")
    
    static let red = Color("red")
}

struct LoginView: View {
    
    
    
    @EnvironmentObject var sessionManager: SessionManger
    @State var validLogin = true
    @State var login = ""
    @State var password = ""
    @State var invalidAttempts = 0
    
    var body: some View {
        VStack {
            
            Group {
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
                
            }
            
            TextField("Username", text: $login)
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
                .padding([.horizontal], 20)
                /*.overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundColor(!validLogin ? Color.clear : Color.red))
                .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))*/
            if !validLogin {
                Text("Error logging in")
                    .font(.system(size: 16.0))
                    .foregroundColor(Color.red)
            }
            // end animation
            
            Button("Forgot password", action:{
                sessionManager.databaseManager.resetPassword(email: "fsbattaglia7@gmail.com")
                sessionManager.showConfirmEmailView()
                })
            .padding([.leading], 219)
            .padding([.top], 8)
            .padding([.bottom], 20)
            
//            Spacer()
                .frame(height: 25)
           
            Button(action:
                    {
                sessionManager.login(
                    username: login,
                    password: password
                )
                self.validLogin = sessionManager.loginValid
               withAnimation(.default) {
                   self.invalidAttempts += 1
                   
                   if !validLogin {
                       Text("Error logging in")
                           .font(.system(size: 16.0))
                           .foregroundColor(Color.red)
                   }
              }
            }, label: {
                Text("Login")
                    .padding()
                    .padding([.horizontal], 38)
                    .foregroundColor(.white)
                    .padding(.horizontal, 100)
                    .background(CustomColor.primarycolor)
                    .cornerRadius(20)
            })
            .padding([.top], 4)
            
            
            /*Button("Login", action: {
                sessionManager.login(
                    username: login,
                    password: password
                )
            }).padding()
                .foregroundColor(.white)
                .padding(.horizontal, 100)
                .background(CustomColor.primarycolor)
                .cornerRadius(20)*/
                
            
            
            Divider()
                .padding([.top], 210)
                .padding([.bottom], 20)
            
    
                
            Button("Don't have an account? Sign up", action:{
                
                sessionManager.showSignUp()
                })
            Spacer()
            
                    
        } .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
}

// animation for wrong password
struct ShakeEffect : GeometryEffect{
    var travelDistance : CGFloat = 6
    var numOfShakes : CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
