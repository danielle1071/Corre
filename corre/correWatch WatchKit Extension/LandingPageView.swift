//
//  LandingPageView.swift
//  correWatch WatchKit Extension
//
//  Created by Danielle Nau on 3/2/22.
//

import SwiftUI

struct LandingPageView: View {
    
    @EnvironmentObject var connector : ConnectionProvider
    @EnvironmentObject var viewManager : ViewManager
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    var body: some View {
        ZStack{
            CusColor.backcolor
                         .ignoresSafeArea()
        VStack{
            
        Text("Corre")
        .foregroundColor(Color("primaryColor"))
        .font(.custom("Proxima Nova Rg Regular", size: 30))
            Text("We're always with you")
                .font(.custom("Proxima Nova Rg Regular", size: 15))
                .foregroundColor(CusColor.primarycolor)
            
            
            
            Image("CreamLogo")
            .resizable()
            .frame(width: 120.0, height: 120.0)
            .scaledToFit()
            
            
//            Button(action: {
//                if connector.controller.currentState == "1" {
//                    self.viewManager.setDashboard()
//                }
//            }, label: {Text("Check")})
            
            if connector.controller.currentState == "1" {
                Button(action: {
                    viewManager.setDashboard()
                    
                }, label: {
                    Text("Start").foregroundColor(Color.black)
                        .font(.custom("Proxima Nova Rg Regular", size: 15))
                        .foregroundColor(CusColor.primarycolor)
                })
            } else {
                Text("")
            }
        
        }
       
        }.onReceive(connector.$controller, perform: {_ in
            if connector.controller.currentState == "1" {
                self.viewManager.setDashboard()
            }
            if connector.controller.currentState == "0" {
                self.viewManager.setLanding()
            }
        })
            
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
