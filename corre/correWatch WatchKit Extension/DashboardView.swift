//
//  DashboardView.swift
//  correWatch WatchKit Extension
//
//  Created by Danielle Nau on 3/2/22.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var connector : ConnectionProvider
    
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
                Text(" Welcome Back!")
                    .foregroundColor(CusColor.primarycolor)
                Spacer()
                HStack{
                Text("Total Runs: 0")
                        .foregroundColor(CusColor.primarycolor)
                        .font(.system(size: 15.0))
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                Spacer()
                
                }
                HStack{
                Text("Total Distance: 0 mi")
                        .foregroundColor(CusColor.primarycolor)
                        .font(.system(size: 15.0))
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        
                Spacer()
                
                }

                Button(action:{
                    print("USER ID ^^^^**** \(connector.controller.usrID)")
                }, label: {
                    Text("Start Run")
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(Capsule())
                })
                   
            Spacer()
            }
        }.onAppear(perform: {
            print("### %%% ### %%% \(connector.controller.usrID)")
        })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
