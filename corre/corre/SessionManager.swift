//
//  SessionManager.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

import Foundation
import Amplify
import Combine
import SwiftUI

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
    case landing
}

final class SessionManger: ObservableObject {
    
    @Published var authState: AuthState = .login
    @Published var databaseManager: DatabaseManager = DatabaseManager()
    
    struct Address: Codable {
        var locality: String
        var region: String
        var postal_code: String
        var country: String
    }
    
    func getCurrentAuthUser() {
        
        // some duck tape and glue :)
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            authState = .login
        }
        else if let user = Amplify.Auth.getCurrentUser() {
            print("This is user: ", user)
            if self.databaseManager.currentUser.isEmpty {
                print("database current user loaded is empty")
                self.databaseManager.getUserProfile(user: user)
            }
            authState = .session(user: user)
        } else {
            authState = .landing
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    
    func signUp(username: String, email: String, phone: String, password: String,
                givenName: String,
                familyName: String,
                dateOfBirth: String,
                locality: String,
                region: String,
                postal_code: String,
                country: String,
                gender: String) {
        let address = Address(locality:locality, region:region, postal_code:postal_code, country:country)
        var jsonString = ""
        do {
            let jsonData = try JSONEncoder().encode(address)
            jsonString = String(data: jsonData, encoding: .utf8)!
        } catch { print(error) }
        let attributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.phoneNumber, value: phone), AuthUserAttribute(.givenName, value: givenName), AuthUserAttribute(.familyName, value:familyName), AuthUserAttribute(.birthDate, value:dateOfBirth), AuthUserAttribute(.gender, value: gender), AuthUserAttribute(.address, value: jsonString)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) { [weak self] result in
                
            switch result {
                
            case .success (let signUpResult):
                print("Sign up result:", signUpResult)
                // This line needs to be moved or removed --- consider overloading this delcaration %%%
                _ = Amplify.Auth.signIn(
                    username: username,
                    password: password
                )
                
                switch signUpResult.nextStep {
                case .done:
                    print("Finished sign up!")
                case .confirmUser(.some(_), let details):
                    print(details)
                    DispatchQueue.main.async {
                       self?.authState = .confirmCode(username: username)
                    }
                case .confirmUser(.none, let details):
                    print("Not sure what this switch does -- details: ", details!)
                }
            case .failure(let error):
                print("Sign up error", error)
            }
        }
    }
    
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: code
        ) { [weak self] result in
            
            switch result {
                
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete{
                    print("SignUp Complete! - Enter Verification Code Step")
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
            case .failure(let error):
                print("failed to confirm code:", error)
                
            }
            
        }
    }
    
    func login(username: String, password: String) {
        _ = Amplify.Auth.signIn(
            username: username,
            password: password
        ) { [weak self] result in
            
            switch result {
            case .success(let signInResult):
                print(signInResult)
                print(Amplify.Auth.fetchUserAttributes())
                switch signInResult.nextStep {
                    case .confirmSignInWithSMSMFACode(_, _):
                        // There is currently no way to get into this case of the switch
                        print("Inside confirmSignInWithSMSMFACode")
                    case .confirmSignInWithCustomChallenge(_):
                        // There is currently no way to get into this case of the switch
                        print("Inside confirmSignInWithCustomeChallenge")
                    case .confirmSignInWithNewPassword(_):
                        // There is currently no way to get into this case of the switch
                        print("Inside confirmSIgnInWIthNewPassword")
                    case .resetPassword(_):
                        // There is currently no way to get into this case of the switch
                        print("Inside resetPassword")
                    case .confirmSignUp(let info):
                        print("Confirm signup additional info \(String(describing: info))")
                        DispatchQueue.main.async {
                           self?.authState = .confirmCode(username: username)
                        }
                    case .done:
                        print("Inside done")
                        
                        //print(Amplify.Auth.fetchUserAttributes())
                        DispatchQueue.main.async {
                            self?.getCurrentAuthUser()
                        }
                }
                
                
                
            case .failure(let error):
                print("Login error:", error)
            }
        }
    }
    
    
        

    func signOut() {
        _ = Amplify.Auth.signOut {
            [weak self] result in
            switch result {
            case .success:
                self!.databaseManager.clearLocalDataOnSignOut()
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
            case .failure(let error):
                print("SignOut error", error)
            }
        }
    }
    
}

