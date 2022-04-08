//
//  ErrorView.swift
//  correWatch WatchKit Extension
//
//  Created by Danielle Nau on 3/15/22.
//

import SwiftUI

struct ErrorView: View {
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
            
        Text("Oops!")
        .foregroundColor(Color("primaryColor"))
        .font(.system(size: 30.0))
            Text("Looks Like Something")
                .font(.system(size: 12.0))
                .foregroundColor(CusColor.primarycolor)
            Text("  Went Wrong!")
                .font(.system(size: 12.0))
                .foregroundColor(CusColor.primarycolor)
            
            
            Image("CreamLogo")
            .resizable()
            .frame(width: 100.0, height: 100.0)
            .scaledToFit()
            
            Spacer()
            Button(action: {
                self.viewManager.setDashboard()
            }, label: {
                Text("Back")
                    .font(.system(size: 12.0))
                    .foregroundColor(CusColor.primarycolor)
            })
        }
       
    }
    
    
    }

    }


struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
