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
        Button("Track Contacts View", action: {
            sessionManager.showTrackContacts()
        }).padding()
            .padding(.horizontal, 108)
            .foregroundColor(CustomColor.primarycolor)
            .background(CustomColor.backcolor)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                .stroke(CustomColor.primarycolor, lineWidth: 2))
        
        VStack{
 
            HStack(alignment: .bottom){
                Button (action: {sessionManager.showSession()}){
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
                
                Spacer()
                Spacer()
                
                Button (action: {showingSheet.toggle()}){
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(Color("primaryColor"))
                    
                    Spacer()
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
                .sheet(isPresented: $showingSheet, content: AddEmergencyContact.init)
                    .padding()
                        .padding(.horizontal, 50)
                        .foregroundColor(CustomColor.primarycolor)
                    .padding(.horizontal, 10)
                    .foregroundColor(CustomColor.primarycolor)
                    .background(CustomColor.backcolor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                        .stroke(CustomColor.primarycolor, lineWidth: 2)
                    )
                
                
            }
            Image("CreamLogo")
            .resizable()
            .frame(width: 125.0, height: 125.0)
            .scaledToFit()

            VStack{
                List(sessionManager.databaseManager.emergencyContacts, id: \.id) { emergencyContact in
                    EmergencyContactRow(emergencyContact: emergencyContact)
                }.onTapGesture(perform: {
                                print("Tapped A Contact")
                    
                })
               
            }
            Divider()
            .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)

        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
//    struct EmergencyContactRow: View {
//
//        var emergencyContact: EmergencyContact
//
//        var body: some View {
//            Text("\(emergencyContact.firstName ?? "") \(emergencyContact.lastName ?? "")")
//        }
//    }
}


struct AddEmergencyContact: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: SessionManger
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""
        
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
                            TextField("Last Name", text: $ecLast)
                            TextField("E-mail or Username", text: $ecEmail)
                            TextField("Phone Number", text: $ecPhone)
                    }
                    .padding(geometry.size.height * 0.02)
                    .padding([.horizontal], geometry.size.width * 0.08)
                    .background(Color("backgroundColor"))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("lightGray"), lineWidth: 1)
                                .padding([.horizontal], geometry.size.width * 0.05)
                    )
                }
                
                Spacer()
                    .frame(height: geometry.size.height * 0.02)
                Button("Create", action: {
                    
                    
                    sessionManager
                        .databaseManager
                        .createEmergencyContactRecord(
                            firstName: ecFirst,
                            lastName: ecLast,
                            searchVal: ecEmail,
                            phoneNumber: ecPhone
                        )
                    close()
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
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } //MARK: THIS IMAGE NEEDS TO BE CHANGED
        .interactiveDismissDisabled()
        .background(
            Image("newContactBackground")
                .scaledToFit()
        )
    }
        
        

    func close() {
        presentationMode.wrappedValue.dismiss()
    }
}
