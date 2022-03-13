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
            Button (action: {sessionManager.showEmergencyContact()}){
            HStack{
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("primaryColor"))
                Text("Emergency Contacts")
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/,40)
                    .foregroundColor(Color("primaryColor"))
                    .font(.system(size: 26.0))
    
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            
            
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 200.0, height: 200.0)
                .scaledToFit()
            
            
            if contact.appUser ?? false {
                Text("Username: \(self.contact.emergencyContactAppUsername ?? "No Username Found")")
                    .font(.system(size: 36.0))
                    .foregroundColor(CustomColor.primarycolor)
            }
            
            Spacer()
                .frame(height: 55)
            
            
            Group {
            TextField("\(contact.firstName ?? "No First Name Saved")", text: $updateFirstName)
            TextField("\(contact.lastName ?? "No Last Name Saved")", text: $updateLastName)
            TextField("\(contact.email)", text: $updateEmail)
            TextField("\(contact.phoneNumber)", text: $updatePhone)
            
            }.font(.system(size: 20.0))
                .foregroundColor(CustomColor.primarycolor)
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/,30)
                
            
            Spacer()
                .frame(height: 55)
            
            HStack{
                
            Button("Update Contact", action: {
                contact.firstName = updateFirstName
                contact.lastName = updateLastName
                contact.phoneNumber = updatePhone
                contact.email = updateEmail
                sessionManager.databaseManager.updateEmergencyContact(contact: contact)
            }).font(.system(size: 20.0))
            
            Text("       ")
                
            Button("Delete Contact", action: {
                sessionManager.databaseManager.deleteEmergencyContact(contactId: contact.id)
                sessionManager.showSession()
            }).font(.system(size: 20.0))
                    .foregroundColor(CustomColor.red)
                
          }
            
        }.onAppear(perform: {
            self.updateFirstName = contact.firstName ?? ""
            self.updateLastName = contact.lastName ?? ""
            self.updateEmail = contact.email
            self.updatePhone = contact.phoneNumber
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
        
    }
        
}

struct EmergencyContactEditView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        let previewContact = EmergencyContact(id: "000", firstName: "L", lastName: "Dawg", email: "TEST@EMAIL.EDU", phoneNumber: "+14078231000", appUser: true, emergencyContactUserId: "0001", userID: "0002", emergencyContactAppUsername: "ldawg")
        EmergencyContactEditView(contact: previewContact)
        
    }
}
