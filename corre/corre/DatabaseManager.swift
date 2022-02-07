//
//  DatabaseManager.swift
//  corre
//
//  Created by Lucas Morehouse on 2/4/22.
//

import Foundation
import Combine
import Amplify
import AWSDataStorePlugin

class DatabaseManager: ObservableObject {
    
    @Published var currentUser = [User]()
    
    func getUserProfile (user: AuthUser) {
        
        let usrKey = User.keys
        Amplify.DataStore.query(User.self, where: usrKey.sub == user.userId) { result in
            print("OUTSIDE THE SWITCH")
            switch(result) {
            case .success(let items):
                for item in items {
                    print("CHECK THIS @@@")
                    print("User ID: \(item.id)")
                    print("This is the item: \(item)")
                    self.currentUser.append(item)
                }
                if items.isEmpty {
                    createUserRecord(user: user)
                    print("Record created for: \(user)")
                    getUserProfile(user: user)
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        /*
        let usrKey = User.keys
        let sink = Amplify.DataStore.query(User.self, where: usrKey.sub == sub).sink {
            if case let .failure(error) = $0 {
                print("Error on query() for type Post - \(error.localizedDescription)")
            }
        }
        receiveValue: { result in
            print("Users Found: \(result)")
            self.currentUser = result
        }
         */
    }
    func getUserProfile (username: String) {
        
        let usrKey = User.keys
        
        Amplify.DataStore.query(User.self, where: usrKey.username == username) { result in
            print("OUTSIDE THE SWITCH")
            switch(result) {
            case .success(let items):
                
                for item in items {
                    print("CHECK THIS @@@")
                    print("User ID: \(item.id)")
                    self.currentUser.append(item)
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        /*
        let usrKey = User.keys
        let sink = Amplify.DataStore.query(User.self, where: usrKey.sub == sub).sink {
            if case let .failure(error) = $0 {
                print("Error on query() for type Post - \(error.localizedDescription)")
            }
        }
        receiveValue: { result in
            print("Users Found: \(result)")
            self.currentUser = result
        }
         */
    }
    
    
    
    func createUserRecord(user: AuthUser) {
        
        let sub = user.userId
        let userName = user.username
        let totalDistance: Double? = 0.0
        let blockedUsers = [String?]()
        let friends = [String?]()
        let bio = ""
        let runningStatus: RunningStatus = RunningStatus.notrunning
        let createdAt = Temporal.DateTime(Date())
        let updatedAt = createdAt
        
        print("Inside the createUserRecordFunction")
        
        let newUser = User(sub: sub, username: userName, bio: bio, totalDistance: totalDistance, runningStatus: runningStatus, friends: friends, blockedUsers: blockedUsers, createdAt: createdAt, updatedAt: updatedAt)
        
        print(newUser)
        
        Amplify.DataStore.save(newUser) { result in
            switch result {
            case .success(_):
                print("Saved")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

    func clearLocalDataOnSignOut() {
        let isSignedOut = HubFilters.forEventName(HubPayload.EventName.Auth.signedOut)
        _ = Amplify.Hub.listen(to: .auth, isIncluded: isSignedOut) { _ in
            Amplify.DataStore.clear() { result in
                switch result {
                case .success:
                    // any time the data gets cleared, we also need to clear it from the
                    self.currentUser.removeAll()
                    print("Local data cleared successfully.")
                case .failure(let error):
                    print("Local data not cleared \(error)")
                }
            }
        }
    }

}
