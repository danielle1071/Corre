//
//  LandingView.swift
//  corre
//
//  Created by Lauren Wright on 2/2/22.
//

import Foundation
import SwiftUI

struct LandingView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    var body: some View{
        
        VStack{
            // Text("HERE: \(sessionManager.databaseManager.currentUser)")
            Text("Corre")
                .font(.system(size: 36.0))
                .foregroundColor(CustomColor.primarycolor)
            Spacer()
                .frame(height: 20)
            
            Text("We're always with you")
                .font(.system(size: 26.0))
                .foregroundColor(CustomColor.primarycolor)
            Spacer()
                .frame(height: 40)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 200.0, height: 200.0)
                .scaledToFit()
            
            Spacer()
                .frame(height: 40)
            
            Button("Sign up", action:{
                sessionManager.showSignUp()
                })
                .padding()
                .foregroundColor(.white)
                .padding(.horizontal, 100)
                .background(CustomColor.primarycolor)
                .cornerRadius(20)
            
            Spacer()
                .frame(height: 20)
            
            Button("Login", action:{
                sessionManager.showLogin()
                })
                .padding()
                .padding(.horizontal, 108)
                .foregroundColor(CustomColor.primarycolor)
                .background(CustomColor.backcolor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(CustomColor.primarycolor, lineWidth: 2)
                )
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            print("LANDING PAGE: \(sessionManager.databaseManager.currentUser)")
        })
        
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView();
    }
}
