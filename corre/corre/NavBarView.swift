//
//  NavBarView.swift
//  corre
//
//  Created by Mariana Botero on 3/1/22.
//

import Foundation
import SwiftUI
import Amplify


struct NavBarView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: SessionManger
    
    @State private var showingSheet = false
    @State private var selectedTab = 0
    @State private var oldSelectedTab = 0
    
    @State var userId = "C8BC189F-E05F-4F80-9507-5B3A556C4330"
    let user: AuthUser
    
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""
    
    var body: some View {
                
        TabView(selection: $selectedTab) {
            SessionView(user: user)
                .onTapGesture {
                    self.selectedTab = 0
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(0)
            
            Text("")
                .tabItem {
                    Image(systemName: "play")
                    Text("Run")
                }.tag(1)
                .onTapGesture {
                    if sessionManager.databaseManager.emergencyContacts.isEmpty {
                        showingSheet.toggle()
                    } else {
                        PreRunningView()
                        self.selectedTab = 1
                    }
                }
        
            MessagesView()
                .onTapGesture {
                    self.selectedTab = 2
                }
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                }.tag(2)
            ProfileView()
                .onTapGesture {
                    self.selectedTab = 3
                }
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }.tag(3)
            
        }
        .onChange(of: selectedTab) {
                       if 1 == selectedTab {
                           if sessionManager.databaseManager.emergencyContacts.isEmpty {
                               showingSheet.toggle()
                           } else {
                               PreRunningView()
                               self.selectedTab = 1
                           }
                       }
                        else {
                           self.oldSelectedTab = $0
                       }
                   }
    
        .sheet(isPresented: $showingSheet, onDismiss: {
            self.selectedTab = self.oldSelectedTab
        }, content: EmergencyPromptSheetNav.init)
        
}
}

struct EmergencyPromptSheetNav: View {
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
//
                    presentationMode.wrappedValue.dismiss()
                    sessionManager.showNavBar()
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

        }
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

    struct NavBarView_Previews: PreviewProvider {
        @EnvironmentObject var sessionManager: SessionManger
        private struct TestUser: AuthUser {
            let userId: String = "1"
            let username: String = "Test"
        }
        static var previews: some View {
            NavBarView(user: TestUser())
        }
    }
