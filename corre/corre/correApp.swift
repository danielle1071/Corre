//
//  correApp.swift
//  corre
//
//  Build Target: iOS 15.0
//  Created by Lucas Morehouse on 11/13/21.
//
// Edited by Mariana Botero on 02/9/21

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
            case .session(let user):
                SessionView(user: user)
                   .environmentObject(sessionManager)
            case .landing:
                LandingView()
                    .environmentObject(sessionManager)
            case .running:
                RunningView()
                    .environmentObject(sessionManager)
            case .profile:
                ProfileView()
//            case .navigation:
//                NavBarView()
//                    .environmentObject(sessionManager)
            case .friend:
                FriendView()
                    .environmentObject(sessionManager)
            case .emergencyContact(let user):
                EmergContactView(/*user: user*/)
                    .environmentObject(sessionManager)
            case .trackRunner(let userTrackingID):
                TrackRunnerView(userTrackingID: userTrackingID)
                    .environmentObject(sessionManager)
            case .navbar:
                NavBarView()
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

