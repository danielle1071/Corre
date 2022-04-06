//
//  LandingPageView.swift
//  correWatch WatchKit Extension
//
//  Created by Danielle Nau on 3/2/22.
//

import SwiftUI

struct LandingPageView: View {
    
    @EnvironmentObject var controller : ConnectionProvider
    
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
            .frame(width: 140.0, height: 140.0)
            .scaledToFit()
            
            Spacer()
        }
       
    }
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView()
    }
}
