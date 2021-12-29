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

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

final class SessionManger: ObservableObject {
    @Published var authState: AuthState = .login
    
    struct Address: Codable {
        var locality: String
        var region: String
        var postal_code: String
        var country: String
    }
    
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .session(user: user)
        } else {
            authState = .login
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
                
                switch signUpResult.nextStep {
                case .done:
                    print("Finished sign up!")
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: username)
                    }
                }
                
            case .failure(let error):
                print("sign up error", error)
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
                
                if signInResult.isSignedIn {
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
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
            case .failure(let error):
                print("SignOut error", error)
            }
        }
    }
    
}
