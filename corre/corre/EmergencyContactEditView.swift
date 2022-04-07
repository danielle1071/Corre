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
                    .font(.custom("Proxima Nova Rg Regular", size: 26))
    
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            
            Spacer()
                .frame(height: 50)
            
            
            Image("emergencyContactLogo")
                .resizable()
                .frame(width: 150.0, height: 150.0)
                .scaledToFit()
            
         
                
            
            if contact.appUser ?? false {
                Text("Username: \(self.contact.emergencyContactAppUsername ?? "No Username Found")")
                    .font(.custom("Proxima Nova Rg Regular", size: 36))
                    .foregroundColor(CustomColor.primarycolor)
            }
            
            Spacer()
                .frame(height: 10)
           
            Text("\(contact.email)")
                .foregroundColor(CustomColor.red)
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/,30)
                    //.shadow(radius: 2.0)
                .font(.custom("Proxima Nova Rg Regular", size: 26))
            
            Spacer()
                .frame(height: 60)
                
            
            Group {
            TextField("\(contact.firstName ?? "No First Name Saved")", text: $updateFirstName)
                    .font(.custom("Proxima Nova Rg Regular", size: 22))
                    .foregroundColor(CustomColor.primarycolor)
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(CustomColor.primarycolor)
                        )
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/,30)
                    //.shadow(radius: 2.0)
            
            Spacer()
                    .frame(height: 30)
                
            TextField("\(contact.lastName ?? "No Last Name Saved")", text: $updateLastName)
                    .font(.custom("Proxima Nova Rg Regular", size: 22))
                    .foregroundColor(CustomColor.primarycolor)
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(CustomColor.primarycolor)
                        )
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/,30)
                    //.shadow(radius: 2.0)
                
            Spacer()
                        .frame(height: 30)
                
            TextField("\(contact.phoneNumber)", text: $updatePhone)
                    .font(.custom("Proxima Nova Rg Regular", size: 22))
                    .foregroundColor(CustomColor.primarycolor)
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(CustomColor.primarycolor)
                        )
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/,30)
                    //.shadow(radius: 2.0)
            
            }
            
            /*.foregroundColor(CustomColor.primarycolor)
                .font(.custom("Proxima Nova Rg Regular", size: 26))
                .padding()
                .background(Color.white)
                .border(CustomColor.primarycolor)
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/,30)
                //.shadow(radius: 2.0)*/
                
            
            
            
            Spacer()
                .frame(height: 130)
            
            HStack{
                
            Button("Update Contact", action: {
                contact.firstName = updateFirstName
                contact.lastName = updateLastName
                contact.phoneNumber = updatePhone
                contact.email = updateEmail
                sessionManager.databaseManager.updateEmergencyContact(contact: contact)
            }).font(.custom("Proxima Nova Rg Regular", size: 20))
            .padding()
            
                
            Button("Delete Contact", action: {
                sessionManager.databaseManager.deleteEmergencyContact(contactId: contact.id)
                sessionManager.showEmergencyContact()
            }).font(.custom("Proxima Nova Rg Regular", size: 20))
                    .foregroundColor(CustomColor.red)
                .padding()
          }
            
        }.onAppear(perform: {
            self.updateFirstName = contact.firstName ?? ""
            self.updateLastName = contact.lastName ?? ""
            //self.updateEmail = contact.email
            self.updatePhone = contact.phoneNumber
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CustomColor.backcolor.edgesIgnoringSafeArea(.all))
        
    }
        
}

struct EmergencyContactEditView_Previews: PreviewProvider {
    static var previews: some View {

    let previewContact = EmergencyContact(
            id: "000",
            firstName: "L",
            lastName: "Dawg",
            email: "TEST@EMAIL.EDU",
            phoneNumber: "+14078231000",
            appUser: true,
            emergencyContactUserId: "0001",
            emergencyContactAppUsername: "ldawg", userID: "0002")
    
        EmergencyContactEditView(contact: previewContact)
    }
}
