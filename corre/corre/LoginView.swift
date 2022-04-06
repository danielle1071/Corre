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
                    .font(.custom("Varela Round Regular", size: 36))
                    .foregroundColor(CustomColor.primarycolor)
                
                Spacer()
                    .frame(height: 25)
                
            }
            
            TextField("Username", text: $login)
                .frame(width: 320, height: 50)
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .padding([.horizontal], 10)
                .background(.white)
                .cornerRadius(15)
                .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("textLight"), lineWidth: 0.8)
            )
            
           
            
            
            SecureField("Password", text: $password)

                .frame(width: 320, height: 50)
                .font(.custom("Proxima Nova Rg Regular", size: 20))
                .padding([.horizontal], 10)
                .background(.white)
                .cornerRadius(15)
                .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("textLight"), lineWidth: 0.8)
                            .foregroundColor(invalidAttempts == 0 ? Color.clear : Color.red)
                )

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
            
            Button("Forgot password?", action:{
                sessionManager.databaseManager.resetPassword(email: "fsbattaglia7@gmail.com")
                sessionManager.showConfirmEmailView()
                })
            .font(.custom("Proxima Nova Rg Regular", size: 18))
            .padding([.leading], 190)
            .padding([.top], 13)
            .padding([.bottom], 10)
            
//            Spacer()
                .frame(height: 25)
           
            Button(action:
                    {
                sessionManager.login(
                    username: login,
                    password: password
                )
                //MARK: Probably not the best way to do this, but it's a viable temp. fix 
                DispatchQueue.main.asyncAfter(deadline:.now() + 0.7) {
                    self.validLogin = sessionManager.loginValid
                    print("Look at this boolean! \(self.validLogin)")
                }
//               withAnimation(.default) {
//                   self.invalidAttempts += 1
//              }
            }, label: {
                Text("Login")
                    .padding([.horizontal], 147)
                    .padding([.vertical],15)
                    .foregroundColor(Color.white)
                    .background(Color("primaryColor"))
                    .cornerRadius(14)
                    .padding([.top], 5)
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
            })

            
            Divider()
                .padding([.top], 190)
                .padding([.bottom], 5)
            
    
                
            Button("Don't have an account? Sign up", action:{
                sessionManager.showSignUp()
                })
            .font(.custom("Proxima Nova Rg Regular", size: 18))
            Spacer()
            
            
            
        }
        .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
            
            
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
