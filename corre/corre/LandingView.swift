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
        
        GeometryReader { geometry in
        
        let gWidth = geometry.size.width
        let gHeight = geometry.size.height
        
            VStack {
                VStack{
                    // Text("HERE: \(sessionManager.databaseManager.currentUser)")
                    
                    Button("Sign up", action:{
                        sessionManager.showSignUp()
                        })
                    .padding([.horizontal], 110)
                    .padding([.vertical],18)
                    .foregroundColor(Color.white)
                    .background(Color("primaryColor"))
                    .cornerRadius(18)
                    .padding([.top], 20)
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    
                    Spacer()
                        .frame(height: 15)
                    
                    Button("Login", action:{
                        sessionManager.showLogin()
                        })
                        .padding([.horizontal], 120)
                        .padding([.vertical],18)
                        .cornerRadius(14)
                        .font(.custom("Proxima Nova Rg Regular", size: 20))
                        .foregroundColor(CustomColor.primarycolor)
                        .background(CustomColor.backcolor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(CustomColor.primarycolor, lineWidth: 2)
                        )
                        
                }
                .padding([.top], gHeight * 0.6)
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background((Image("Landing")).edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            print("LANDING PAGE: \(sessionManager.databaseManager.currentUser)")
        })
        
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView();
    }
}
