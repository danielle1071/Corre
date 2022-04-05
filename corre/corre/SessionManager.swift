//
//  SessionManager.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//
// Modified by Mariana Botero on 03/01/2021

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
    case running(phoneNumber: String)
    case profile
    case emergencyContact(contacts: [EmergencyContact])
    case trackContacts
    case trackRunner(userTrackingID: String)
    case nav(user: AuthUser)
    case messaging(userId: String, friendId: String)
    case notification
    case friendView
    case preRun
    case messageFriendView
    case confirmPassResetView(email: String)
    case confirmEmailView




    case pendingReqs(requests: [Notification])

    case editEmergencyContact(contact: EmergencyContact)
    case errV



}

final class SessionManger: ObservableObject {
    
    @Published var isSignedIn = false
    @Published var authState: AuthState = .login
    @ObservedObject var databaseManager: DatabaseManager = DatabaseManager()
    @Published var loginValid = true
    
    struct Address: Codable {
        var locality: String
        var region: String
        var postal_code: String
        var country: String
    }
    
    // MARK: getCurrentAuthUser
    func getCurrentAuthUser() {
        DispatchQueue.main.async {
            // some duck tape and glue :)
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                self.authState = .login
            }
            else if let user = Amplify.Auth.getCurrentUser() {
                print("This is user: ", user)
                if self.databaseManager.currentUser == nil {
                    print("database current user loaded is empty")
                    Task() {
                            do {
                                try await self.databaseManager.getUserProfile(user: user)
                                try await self.databaseManager.createDeviceRecord()
                                try await self.databaseManager.getEmergencyContacts()
                                try await self.databaseManager.getRunnerRecords()
                                self.databaseManager.getUserRunLogs()
                                try await self.databaseManager.getFriends()
                            } catch {
                                print("ERROR IN GET CURRENT AUTH USER")
                            }
                    }
                }
                self.authState = .nav(user: user)
            } else {
                self.authState = .landing
            }
        }
    }
    
    // MARK: showSignUp
    func showSignUp() {
        authState = .signUp
    }
    
    // MARK: signUp
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
    
    // MARK: confirm
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
    
    // MARK: showLogin
    func showLogin() {
        authState = .login
    }
    
    // MARK: login
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
//                    self.loginValid = true
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
                    self?.loginValid = true
                        //print(Amplify.Auth.fetchUserAttributes())
                        DispatchQueue.main.async {
                            self?.getCurrentAuthUser()
                        }
                    
                }
                
                
                
            case .failure(let error):
                self?.loginValid = false
                print("Login error:", error)
            }
        }
    }
    
    // MARK: signOut
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
    
    // MARK: showSession
    func showSession() {
        if let user = Amplify.Auth.getCurrentUser() {
            self.showNavBar()
            databaseManager.getEmergencyContacts()
//            authState = .session(user: user)
        } else {
            authState = .landing
        }
    }
    
    
    
    // MARK: showNavBar
    func showNavBar() {
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .nav(user: user)
        } else {
            authState = .landing
        }
    }

    
    // MARK: showRunning
    func showRunning(phoneNumber: String) {
        authState = .running(phoneNumber: phoneNumber)
    }
    
    // MARK: showTrackContacts
    func showTrackContacts() {
        authState = .trackContacts
    }
    
    // MARK: showTrack
    func showTrack(userTrackingID: String) {
        authState = .trackRunner(userTrackingID: userTrackingID)
    }
    
    // MARK: showProfile
    func showProfile() {
        if databaseManager.currentUser != nil {
            authState = .profile
            
            Task() {
                do { await databaseManager.getUserRunLogs() }
                catch { print("SessionManager -> showProfile -> ERROR IN SHOW SESSION") }
            }
        } else {
            authState = .errV
        }
    }
    func showMessage(friendId: String) {
        if databaseManager.currentUser == nil {
            getCurrentAuthUser()
        }
        let userId = databaseManager.currentUser!.id
        authState = .messaging(userId: userId, friendId: friendId)
    }
    
    // MARK: showEmergencyContact
    func showEmergencyContact() {
        databaseManager.getEmergencyContacts()
        authState = .emergencyContact(contacts: databaseManager.emergencyContacts)
//        if let user = Amplify.Auth.getCurrentUser() {
//            authState = .emergencyContact(user: user)
//        } else {
//            authState = .landing
//        }
    }
    
    // MARK: showFriendView
    func showFriendView() {
        databaseManager.getFriends()
        authState = .friendView
    }
    
    func showMessageFriendView() {
        databaseManager.getFriends()
        authState = .messageFriendView
    }
    
    // MARK: showNotificationView
    func showNotificationView() {
        Task () {
            do {
                await databaseManager.getNotifications()
            } catch {
                print("ERROR IN SHOW SESSION")
            }
        }
        authState = .notification
    }
    
    func showPreRunning() {
        authState = .preRun
    }
    

    func showPendingRequests() {
        let listReqs = databaseManager.getFriendRequestsSent()
        authState = .pendingReqs(requests: listReqs)

    }
    func showEditContact(contact: EmergencyContact) {
        authState = .editEmergencyContact(contact: contact)

    }
    
    func showConfirmPassResetView(email: String){
        authState = .confirmPassResetView(email: email)
    }
    
    func showConfirmEmailView(){
        authState = .confirmEmailView
    }
}

// Need to build a list of friend users
// Need to build a list of friend requests sent
