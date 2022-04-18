//
//  EmergContactView.swift
//  corre
//  Skeleton
//  Created by Mariana Botero on 2/7/22.
//
//  SwiftUIView.swift
//  Profile-page
//
//  Created by Danielle Nau on 2/8/22.
//
//  Adapted by Lucas Morehouse on 2/10/22.
//

import SwiftUI
import Foundation
import Amplify
import Combine
import AmplifyMapLibreUI

struct EmergContactView: View {
    
    @State private var showingSheet = false
    @EnvironmentObject var sessionManager: SessionManger
    @State var contacts: [EmergencyContact]
    // @ObservedObject var contacts = EmergencyContactStore()
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""
    
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
                Button (action: {
                    sessionManager.showSession()
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
                  .foregroundColor(Color("primaryColor"))
                
    
                Button (action: {
                    showingSheet.toggle()
                }){
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(Color("primaryColor"))
                        Text("Add New Contact")
                            .font(.custom("Varela Round Regular", size: 18))
                            .foregroundColor(Color("primaryColor"))
                    }
                }
                .sheet(isPresented: $showingSheet, content: AddEmergencyContact.init)
            }
            .padding(.all)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
                        
            Text("Emergency Contacts")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack {
                List() {
                    ForEach ( contacts, id: \.id) {
                        emergencyContact in EmergencyContactRow(emergencyContact: emergencyContact)
                            .onTapGesture(perform: {
                                print("Tapped A Contact: \(emergencyContact)")
                                sessionManager.showEditContact(contact: emergencyContact)
                            })
                    }
                    .onDelete(perform: delete)
                }
                .font(.custom("Proxima Nova Rg Regular", size: 18))
                
                
//                Button(action: {
//                        sessionManager.showTrackContacts()
//                }, label: {
//                    Text("Track Contacts View")
//                        .fontWeight(.bold)
//                        .font(.custom("Varela Round Regular", size: 18))
//                        .padding()
//                        .padding(.horizontal, 50)
//                        .background(Color("primaryColor"))
//                        .foregroundColor(Color.white)
//                        .clipShape(Capsule())
//                        .shadow(radius: 2)
//                })
                    
                
            }
            Spacer()
            
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
    func delete(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let contact = sessionManager.databaseManager.emergencyContacts[index]
            print("This is the contact to delete \(contact)")
            sessionManager.databaseManager.deleteEmergencyContact(contactId: contact.id)
        }
        
        sessionManager.databaseManager.getEmergencyContacts()
        contacts = sessionManager.databaseManager.emergencyContacts
    }
}


struct AddEmergencyContact: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: SessionManger
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""
    @State var userExist = true
    @State var addYourself = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Text("Start running safely.")
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(CustomColor.primarycolor)
                    .opacity(0.5)
                    .padding([.horizontal], geometry.size.width * 0.09)
                    .padding([.top], geometry.size.height * 0.32)
                    .padding([.bottom], geometry.size.height * 0.02)
                    
                VStack (alignment: .center) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.03)
                    
                    VStack (alignment: .center, spacing: 20){
                        Group {
                            TextField("First Name", text: $ecFirst)
                                .padding(geometry.size.height * 0.02)
                                .padding([.horizontal], geometry.size.width * 0.08)
                                .background(Color("backgroundColor"))
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("lightGray"), lineWidth: 1)
                                            .padding([.horizontal], geometry.size.width * 0.05)
                                )
                            TextField("Last Name", text: $ecLast)
                                .padding(geometry.size.height * 0.02)
                                .padding([.horizontal], geometry.size.width * 0.08)
                                .background(Color("backgroundColor"))
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("lightGray"), lineWidth: 1)
                                            .padding([.horizontal], geometry.size.width * 0.05)
                                )
                            TextField("E-mail or Username", text: $ecEmail)
                                .padding(geometry.size.height * 0.02)
                                .padding([.horizontal], geometry.size.width * 0.08)
                                .background(Color("backgroundColor"))
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("lightGray"), lineWidth: 1)
                                            .padding([.horizontal], geometry.size.width * 0.05)
                                )
                            if addYourself {
                                Text("Error: Cannot Add Yourself")
                                    .font(.system(size: 10.0))
                                    .foregroundColor(Color.red)
                                
                            }
                            if !userExist {
                                Text("Error: User Not Found")
                                    .font(.system(size: 10.0))
                                    .foregroundColor(Color.red)
                            }
                            TextField("Phone Number", text: $ecPhone)
                                .padding(geometry.size.height * 0.02)
                                .padding([.horizontal], geometry.size.width * 0.08)
                                .background(Color("backgroundColor"))
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("lightGray"), lineWidth: 1)
                                            .padding([.horizontal], geometry.size.width * 0.05)
                                )
                        }
                        
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.02)
                    Button("Create", action: {
                        
                        var user =
                        sessionManager.databaseManager.getUserProfile(username: self.ecEmail.lowercased())
                        if user == nil {
                            addYourself = false
                            user = sessionManager.databaseManager.getUserProfile(email: self.ecEmail.lowercased())
                        }
                        
                        print("Here is the user in the emergency contact view: \(user)")
                        if user != nil && sessionManager.databaseManager.currentUser != nil{
                            userExist = true
                                if sessionManager.databaseManager.currentUser!.id == user!.id {
                                    addYourself = true
                                } else {
                                    addYourself = false
                                sessionManager.databaseManager.sendEmergencyContactRequest(user: user!, firstName: ecFirst, lastName: ecLast, phoneNumber: ecPhone)
                                close()
                                }
                            
                        } else {
                            userExist = false
                        }
                        
                    })
                        .font(.custom("Proxima Nova Rg Regular", size: 20))
                        .padding([.horizontal], geometry.size.width * 0.32)
                        .padding([.vertical], geometry.size.height * 0.02)
                        .foregroundColor(Color.white)
                        .background(Color("primaryColor"))
                        .cornerRadius(14)
                       
                    Spacer()
                        .frame(height: geometry.size.height * 0.03)
                
                }
                
                        .background(Color("backgroundColor"))
                        .cornerRadius(10)
                        .frame(width: geometry.size.width * 0.90,
                               height: geometry.size.height * 0.50)
                        .background(Color.gray
                                                .opacity(0.08)
                                                .shadow(color: .gray, radius: 6, x: 0, y: 4)
                                                .blur(radius: 8, opaque: false)
                        )
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.04)
                
                Button("Dismiss", action: close)
                    .font(.custom("Varela Round Regular", size: 20))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } //MARK: THIS IMAGE NEEDS TO BE CHANGED
        .interactiveDismissDisabled()
        .background(
            Image("newContactBackground")
                .scaledToFit()
        )
    }
        
        

    func close() {
        presentationMode.wrappedValue.dismiss()
        
        sessionManager.databaseManager.getEmergencyContacts()
        EmergContactView(contacts: sessionManager.databaseManager.emergencyContacts)
    }
}
