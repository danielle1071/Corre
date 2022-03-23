//
//  PreRunningView.swift
//  corre
//
//  Created by Lucas Morehouse on 2/28/22.
//

import SwiftUI

struct PreRunningView: View {
    
    
    @EnvironmentObject var sessionManager: SessionManger
    var DEBUG = true

    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }

    var body: some View {
        
        // MARK: this needs to be a tab.. placeholder
        
        VStack{
            HStack{
                Button(action: {
                sessionManager.showNavBar()
            }, label: {
                Image(systemName: "arrow.left")
                    .renderingMode(.original)
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color("primaryColor"))
                Text("Back")
                    .font(.custom("Varela Round Regular", size: 18))
                    .foregroundColor(Color("primaryColor"))
                })
                Spacer()
                
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
            
            Text("Who would you like to call in case of an Emergency?")
                .font(.custom("Varela Round Regular", size: 18))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer()
            Spacer()
                
            VStack{
                List(sessionManager.databaseManager.emergencyContacts, id: \.id) { emergencyContact in
                    EmergencyContactRow(emergencyContact: emergencyContact)
                        .onTapGesture(perform: {
                            sessionManager.showRunning(phoneNumber: emergencyContact.phoneNumber)
                            self.startRunNotif()
                        })
                }
            }
            
            Divider()
            .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
    func startRunNotif() {
        sessionManager.databaseManager.getEmergencyContacts()
        let contacts = sessionManager.databaseManager.emergencyContacts
        
        contacts.forEach { contact in contacts
            if (DEBUG) {
                print("PreRunningView -> Emergency Contact: \(contact.id) and \(contact.emergencyContactAppUsername)")
            }
            
            // In the event that the emergency has an account through corre
            if (contact.emergencyContactAppUsername != nil) {
                print("DO THE THANG")
            }
            
            // 1EBB9239-8A8B-4326-B8AB-436268DBA895
            
        }
        
    }
}

struct PreRunningView_Previews: PreviewProvider {
    static var previews: some View {
        PreRunningView()
    }
}
