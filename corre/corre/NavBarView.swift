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
    
    
    init(user: AuthUser) {
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "primaryColor")
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "Varela Round Regular", size: 12)! ], for: .normal)
        self.user = user
    }
    

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sessionManager: SessionManger

    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""
    
    
    @State var userId = "C8BC189F-E05F-4F80-9507-5B3A556C4330"
    let user: AuthUser
    
    @State var showingSheet = false
    @State var selectedTab = 0
    @State var oldSelectedTab = 0
    
    var body: some View {
      
        
        let home = Image("home.nofill")
                    .font(.system(size: 60))
        
        let homePressed = Image("home.fill")
                    .font(.system(size: 60))
        
        let run = Image("run.nofill")
                    .font(.system(size: 60))
        
        let runPressed = Image("run.fill")
                    .font(.system(size: 60))
        
        let friends = Image("friends.nofill")
                    .font(.system(size: 60))
        
        let friendsPressed = Image("friends.fill")
                    .font(.system(size: 60))
        
        let stats = Image("stats.nofill")
                    .font(.system(size: 60))
        
        let statsPressed = Image("stats.fill")
                    .font(.system(size: 60))
                
        TabView(selection: $selectedTab) {
            SessionView(user: user)
                .onTapGesture {
                    self.selectedTab = 0
                }
                .tabItem {
                    selectedTab == 0 ? homePressed : home
                    Text("Home")
                }.tag(0)
            
            PreRunningView()
                .tabItem {
                    selectedTab == 1 ? runPressed : run
                    Text("Run")
                }.tag(1)
                .onTapGesture {
                    if sessionManager.databaseManager.emergencyContacts.isEmpty {
                        showingSheet.toggle()
                    } else {
                        sessionManager.showPreRunning()
                        self.selectedTab = 1
                    }
                }
            FriendView()
                .onTapGesture {
                    self.selectedTab = 2
                }
                .tabItem {
                    selectedTab == 2 ? friendsPressed : friends
                    Text("Friends")
                }.tag(2)
            
            
            RunHistoryView()
                .onTapGesture {
                    self.selectedTab = 3
                }
                .tabItem {
                    selectedTab == 3 ? statsPressed : stats
                    Text("Stats")
                }.tag(3)
            
        }
        .accentColor(Color("primaryColor"))
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
//
//    struct NavBarView_Previews: PreviewProvider {
//        @EnvironmentObject var sessionManager: SessionManger
//        private struct TestUser: AuthUser {
//            let userId: String = "1"
//            let username: String = "Test"
//        }
//        static var previews: some View {
//            NavBarView(user: TestUser())
//        }
//    }
