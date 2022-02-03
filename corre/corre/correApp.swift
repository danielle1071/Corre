//
//  correApp.swift
//  corre
//
//  Build Target: iOS 15.0
//  Created by Lucas Morehouse on 11/13/21.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import AWSLocationGeoPlugin

@main
struct correApp: App {
    
    @ObservedObject var sessionManager = SessionManger()
    
    init() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            sessionManager.authState = .login
        } else {
            configureAmplify()
            sessionManager.getCurrentAuthUser()
            
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
            }
            
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSLocationGeoPlugin())
            try Amplify.configure()
            print("SUCCESS! APLIFY CONFIGURED!")
        } catch {
            print("SAD 😢 --- could not initialize Amplify", error)
        }
    }
}

