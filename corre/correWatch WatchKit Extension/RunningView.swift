//
//  RunningView.swift
//  correWatch WatchKit Extension
//
//  Created by Danielle Nau on 3/2/22.
//

import SwiftUI

struct RunningView: View {
    
    
    @EnvironmentObject var connector : ConnectionProvider
    @EnvironmentObject var viewManager : ViewManager
    var phone : String
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
   // emergency contact phone number example
    
    var body: some View {
        ZStack{
            CusColor.backcolor
                         .ignoresSafeArea()
       
            VStack{
               
                HStack{
                    Text("Distance: 0 mi")
                        .foregroundColor(CusColor.primarycolor)
                        .font(.system(size: 12.0))
                        .padding(.all)
                    Spacer()
                }
                HStack{
                    Text("Speed: 0 m/s")
                        .foregroundColor(CusColor.primarycolor)
                        .font(.system(size: 12.0))
                        .padding(.all)
               Spacer()
                }
                
                HStack{
                    Text("Heart Rate: 0 bpm")
                        .foregroundColor(CusColor.primarycolor)
                        .font(.system(size: 12.0))
                        .padding(.all)
                        
                    Image(systemName: "bolt.heart.fill")
                    .resizable()
                    .frame(width: 15.0, height: 15.0)
                    .scaledToFit()
                    .foregroundColor(Color.red)
                    
               Spacer()
                }
                
                
               
                HStack {
                
                Button(action:{
                }, label: {
                    Text("Pause Run")
                        .frame(width: 90, height: 40)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(Capsule())
                })
                
                
                Button(action:{
                }, label: {
                    Text("End Run")
                        .frame(width: 90, height: 40)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(Capsule())
                })
                
                }
                
                Button(action:{
                    if let telURL = URL(string: "tel:\(phone)") {
                    let wkExt = WKExtension.shared()
                    wkExt.openSystemURL(telURL)
                    }
                 
                   
                }, label: {
                    Text("SOS")
                        .frame(width: 120, height: 40)
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .clipShape(Capsule())
                })
                    
            Spacer()
            }
        }
    }
}

//struct RunningView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunningView()
//    }
//}
