//
//  correApp.swift
//  corre
//
//  Build Target: iOS 15.0
//  Created by Lucas Morehouse on 11/13/21.
//
// Modified by Mariana Botero on 03/01/2021

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import AWSLocationGeoPlugin
import AWSDataStorePlugin

@main
struct correApp: App {
    
    @ObservedObject var sessionManager = SessionManger()
    
    
    init() {
        
        // print("Number of users loaded: \(databaseManager.currentUser.count)")
        // print("Number of curent users loaded: \(databaseManager.get")
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            sessionManager.authState = .login
        }
        
        
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            sessionManager.authState = .login
        } else {
            configureAmplify()
            
            // MARK: tracking test
            // sessionManager.observedAuthEvents()
            
            Amplify.DataStore.start { (result) in
                switch(result) {
                case .success:
                    print("DataStore started")
                case .failure(let error):
                    print("Error starting DataStore:\(error)")
                }
            }
            sessionManager.getCurrentAuthUser()
            // print("Number of current users loaded: \(sessionManager.databaseManager.currentUser.count)")
            
        }
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            
    
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
            case .confirmCode(let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionManager)
            case .nav(let user):
                NavBarView(user: user)
                   .environmentObject(sessionManager)
            case .session(let user):
                SessionView(user: user)
                   .environmentObject(sessionManager)
            case .landing:
                LandingView()
                    .environmentObject(sessionManager)
            case .running(let phoneNumber):
                RunningView(phoneNumber: phoneNumber)
                    .environmentObject(sessionManager)
            case .profile:
                ProfileView()
                    .environmentObject(sessionManager)
            // Note: let User: was causing EXC_I386_GPFLT error through trackContacts
            case .emergencyContact(_):
                EmergContactView(/*user: user*/)
                    .environmentObject(sessionManager)
            case .trackRunner(let userTrackingID):
                TrackRunnerView(userTrackingID: userTrackingID)
                    .environmentObject(sessionManager)
            case .trackContacts:
                TrackContactsView()
                    .environmentObject(sessionManager)
            case .messaging:
                MessagesView()
                    .environmentObject(sessionManager)
            case .notification:
                NotificationView()
                    .environmentObject(sessionManager)
            case .friendView:
                FriendView()
                    .environmentObject(sessionManager)
            case .preRun:
                PreRunningView()
                    .environmentObject(sessionManager)

            case .pendingReqs(let requests):
                SentFriendReqView(requests: requests)
                    .environmentObject(sessionManager)
            case .editEmergencyContact(let contact):
                EmergencyContactEditView(contact: contact)
                    .environmentObject(sessionManager)
                
            case .errV:
                Error1View()
                    .environmentObject(sessionManager)
            }
            
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSLocationGeoPlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("SUCCESS! AMPLIFY CONFIGURED!")
        } catch {
            print("SAD 😢 --- could not initialize Amplify", error)
        }
    }
}

