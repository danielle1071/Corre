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
    
    func getUserProfile (sub: String) {
        
        let usrKey = User.keys
        Amplify.DataStore.query(User.self, where: usrKey.sub == sub) { result in
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



}
