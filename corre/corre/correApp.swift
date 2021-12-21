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

@main
struct correApp: App {
    
    @ObservedObject var sessionManager = SessionManger()
    
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
        
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
            }
            
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("SUCCESS! APLIFY CONFIGURED!")
        } catch {
            print("SAD 😢 --- could not initialize Amplify", error)
        }
    }
}

