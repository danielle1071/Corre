//
//  SelectContactView.swift
//  correWatch WatchKit Extension
//
//  Created by Danielle Nau on 3/15/22.
//

import SwiftUI

struct SelectContactView: View {
    
    @EnvironmentObject var connector : ConnectionProvider
    @EnvironmentObject var viewManager : ViewManager
    var runMan : RunningManager
    var postManager = PostManager()
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
  
    var body: some View {
        ZStack{
            CusColor.backcolor.edgesIgnoringSafeArea(.all)
            VStack{
            HStack{
                Text("Select Emergency Contact")
                    .foregroundColor(Color("primaryColor"))
                }
           
                List(runMan.emergencyContacts.emergencyContacts, id: \.id) { emergencyContact in
                    Button (action: {
                        
                        if runMan.runningStatus.status == "RUNNING" {
                            self.viewManager.setError()
                        }
                        else {
                            postManager.startRunNotification(id: connector.controller.usrID)
                            self.viewManager.setRunning(number: emergencyContact.phoneNumber, runMan: self.runMan)
                        }
                    }){
                        HStack{
                            VStack{
                                Text("\(emergencyContact.firstName)")
                                    .foregroundColor(Color("primaryColor"))
                                Text("\(emergencyContact.lastName)")
                                    .foregroundColor(Color("primaryColor"))
                            }
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color("primaryColor"))
                        }
                       
                        }
                    .listRowBackground(Color.clear)
                }
                
//                List {
//                Button (action: {
//
//                }){
//                    HStack{
//                        Text("Jane Doe")
//                            .foregroundColor(Color("primaryColor"))
//                        Spacer()
//                        Image(systemName: "arrow.right")
//                            .foregroundColor(Color("primaryColor"))
//                    }
//
//                    }
//                .listRowBackground(Color.clear)
//                    }
                Button(action:{
                    viewManager.setDashboard()
                }, label: {
                    Text("Back")
                        .fontWeight(.bold)
                        .frame(width: 125.0, height: 40.0)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(Capsule())
                })
            
            }
        }
    }
    }


//struct SelectContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectContactView()
//    }
//}
