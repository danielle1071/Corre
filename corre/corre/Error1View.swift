//
//  Error1View.swift
//  corre
//
//  Created by Lauren Wright on 2/21/22.
//  Page for Error "getCurrentUserLocation
// - userName: nil" from RunningView specifically
//
//  Can be used for all errors
//

import Foundation
import SwiftUI

struct Error1View: View {
    
    struct CColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    
    @EnvironmentObject var sessionManager: SessionManger
    
    var body: some View{
        
        VStack{
            
            Text("Oops!")
                .font(.system(size: 50.0))
                .foregroundColor(CustomColor.primarycolor)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 250.0, height: 250.0)
                .scaledToFit()
            
            Text("Something went wrong...")
                .font(.system(size: 30.0))
                .foregroundColor(CustomColor.primarycolor)
            
            Spacer()
                .frame(height: 10)
            
            Button("Back to dashboard", action: {
            sessionManager.showSession()
            })
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
    }
}

struct Error1View_Previews: PreviewProvider {
    static var previews: some View {
        Error1View()
    }
}
