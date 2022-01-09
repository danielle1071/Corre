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

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    // add case profileCreate(user: CognitoUser)
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
            print("This is user: ", user)
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
                // This line needs to be moved or removed --- consider overloading this delcaration %%%
                _ = Amplify.Auth.signIn(
                    username: username,
                    password: password
                )
                // let userCheck = Amplify.Auth.getCurrentUser()
                switch signUpResult.nextStep {
                case .done:
                    print("Finished sign up!")
                case .confirmUser(let details):
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
                    print("SignUp Complete! - Enter Verification Code Step")
                    // print(Amplify.Auth.getCurrentUser())
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
                        let user = Amplify.Auth.getCurrentUser()
                        DispatchQueue.main.async {
                            self?.authState = .confirmCode(username: username)
                        }
                    case .done:
                        print("Inside done")
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
    
    func resendCode() -> AnyCancellable {
        _ = print(Amplify.Auth.getCurrentUser())
        return Amplify.Auth.resendConfirmationCode(for: .email)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Resend code failed with error \(authError)")
                }
            }
            receiveValue: { deliveryDetails in
                print("Resend code sent to - \(deliveryDetails)")
            }
    }
    
}
