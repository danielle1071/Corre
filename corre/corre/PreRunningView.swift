//
//  PreRunningView.swift
//  corre
//
//  Created by Lucas Morehouse on 2/28/22.
//

import SwiftUI

struct PreRunningView: View {
    
    
    @EnvironmentObject var sessionManager: SessionManger

    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }

    var body: some View {
        
        // MARK: this needs to be a tab.. placeholder
        
        VStack{
            Text("Choose The Emergency Contact To Call If SOS")
//            HStack(alignment: .bottom){
                Button (action: {sessionManager.showSession()}){
                HStack{
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color("primaryColor"))
                    Text("Back")
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
                
                Spacer()
                Spacer()
                
                
            Image("CreamLogo")
            .resizable()
            .frame(width: 125.0, height: 125.0)
            .scaledToFit()

            VStack{
                List(sessionManager.databaseManager.emergencyContacts, id: \.id) { emergencyContact in
                    EmergencyContactRow(emergencyContact: emergencyContact)
                        .onTapGesture(perform: {
                            sessionManager.showRunning(phoneNumber: emergencyContact.phoneNumber)
                        })
                }
               
            }
            Divider()
            .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)

            }
            .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
//        }
    }
}

struct PreRunningView_Previews: PreviewProvider {
    static var previews: some View {
        PreRunningView()
    }
}
