//
//  EmergencyContactEditView.swift
//  corre
//
//  Created by Lucas Morehouse on 3/6/22.
//

import SwiftUI

struct EmergencyContactEditView: View {
    
    @State var contact: EmergencyContact
    @EnvironmentObject var sessionManager: SessionManger
    @State var updateFirstName = ""
    @State var updateLastName = ""
    @State var updatePhone = ""
    @State var updateEmail = ""
    
    
    var body: some View {
        VStack {
            if contact.appUser ?? false {
                Text("Username: \(self.contact.emergencyContactAppUsername ?? "No Username Found")")
            }
            Button (action: {sessionManager.showEmergencyContact()}){
            HStack{
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("primaryColor"))
                Text("Emergency Contacts")
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor"))
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            TextField("\(contact.firstName ?? "No First Name Saved")", text: $updateFirstName)
            TextField("\(contact.lastName ?? "No Last Name Saved")", text: $updateLastName)
            TextField("\(contact.email)", text: $updateEmail)
            TextField("\(contact.phoneNumber)", text: $updatePhone)
            
            Button("Update Contact", action: {
                contact.firstName = updateFirstName
                contact.lastName = updateLastName
                contact.phoneNumber = updatePhone
                contact.email = updateEmail
                sessionManager.databaseManager.updateEmergencyContact(contact: contact)
            })
        }.onAppear(perform: {
            self.updateFirstName = contact.firstName ?? ""
            self.updateLastName = contact.lastName ?? ""
            self.updateEmail = contact.email
            self.updatePhone = contact.phoneNumber
        })
        
    }
}

struct EmergencyContactEditView_Previews: PreviewProvider {
    static var previews: some View {
        
            Text("Hello, World!")
        
    }
}
