//
//  DatabaseManager.swift
//  corre
//
//  Created by Lucas Morehouse on 2/4/22.
//  Updated on 2/14/22
//

//MARK: Need to add function to get user attributes to find first and last name of from the user pool
//MARK: to add to the user record in the database 

import Foundation
import Combine
import Amplify
import AWSDataStorePlugin

class DatabaseManager: ObservableObject {
    
    @Published var currentUser:User?
    
    @Published var emergencyContacts = [EmergencyContact]()
    
    @Published var deviceTracking:Device?
    

    @Published var runners = [EmergencyContact]()
    


    @Published var notifications = [Notification]()
    



    var subscriptions = Set<AnyCancellable>()
    
    func getUserProfile (user: AuthUser) async {

        
        let usrKey = User.keys
        await Amplify.DataStore.query(User.self, where: usrKey.sub == user.userId) { result in
            print("RESULT: \(result)")
            print("OUTSIDE THE SWITCH")
            switch(result) {
            case .success(let items):
                if items.count > 1 {
                    print("ERROR --- More than 1 user record exists, using first one found")
                    self.currentUser = items[0]
                } else {
                    for item in items {
                        print("CHECK THIS @@@")
                        print("User ID: \(item.id)")
                        print("This is the item: \(item)")
                        self.currentUser = item
                    }
                }
                if items.isEmpty {
                    print("NO USER RECORD FOUND")
                    createUserRecord(user: user)
                    print("Record created for: \(user)")
                    // getUserProfile(user: user)

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
    
    func getUserProfile (userID: String) -> User? {
        var retVal: User?
        Amplify.DataStore.query(User.self, byId: userID) { result in
            switch result {
            case .success(let item):
                if result == nil {
                    print("No user found in the getUserProfile(By user ID)")
                } else {
                    print("Found the user! : \(result)")
                }
                retVal = item
            case .failure(let error):
                print("Error on query() for type Users - \(error.localizedDescription)")
                retVal = nil
            }
        }
        return retVal
    }
    
    func getUserProfile (username: String) {
//        DispatchQueue.main.async {
            let usrKey = User.keys
            
            Amplify.DataStore.query(User.self, where: usrKey.username == username) { result in
                print("OUTSIDE THE SWITCH")
                switch(result) {
                case .success(let items):
                    //MARK: Need to update
                    for item in items {
                        print("CHECK THIS @@@")
                        print("User ID: \(item.id)")
                        self.currentUser = item
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
//        }
    }
    
    func createDeviceRecord() {
        if currentUser == nil {
            print("No user loaded - can't create device record")
            
            return
        }
        let deviceKeys = Device.keys
        let userDeviceID = currentUser?.id
        let newDevice = Device(userDeviceID: userDeviceID)
        
        Amplify.DataStore.query(Device.self, where: deviceKeys.userDeviceID == userDeviceID) { result in
            print("OUTSIDE THE SWITCH -- Create Device Record")
            switch(result) {
            case .success(let items):
                if items.isEmpty {
                    Amplify.DataStore.save(newDevice) { result in
                        switch result {
                        case .success(_):
                            print("Saved new device record")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    print ("record already exists for this device!")
                }
            case .failure(let error):
                print("Could not query DataStore: \(error) --- Create Device Record $$$")
            }
        }
        print("End of create device record function")
    }
    
//    func createDeviceRecord (userDeviceID: String) {
//
//        let device = Device(userDeviceID: userDeviceID)
//
//    }

    func findDeviceRecord (userDeviceID: String) -> Device? {
        
        let deviceKeys = Device.keys
        var retVal: Device?
        Amplify.DataStore.query(Device.self, where: deviceKeys.userDeviceID == userDeviceID) { result in
            print("OUTSIDE THE SWITCH for device record query")
            switch(result) {
            case .success(let items):
                if items.count > 1 {
                    print("More than one device record found, returning the first $$$")
                    retVal = items[0]
                } else if items.isEmpty {
                    print("No device record found for specified ID $$$")
                } else {
                    retVal = items[0]
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return retVal
    }
    
    func updateDeviceLocation(device: Device, xCord: Double, yCord: Double) {
        var updateDevice = device
        updateDevice.xCord = xCord
        updateDevice.yCord = yCord
        Amplify.DataStore.save(updateDevice) { result in
            switch result {
            case .success(_):
                print("Updated coordinates!")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setRunStatus(status: RunningStatus) {
        if currentUser == nil {
            print("Error --- can't update running status, currentUser is empty")
            return
        } else {
            var user = currentUser
            user?.runningStatus = status
            Amplify.DataStore.save(user!) { result in
                switch result {
                case .success(_):
                    print("Updated User Record")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
        var firstName = ""
        var lastName = ""
        var email = "doNotEmail@ERROR.com".lowercased()
        
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                for attribute in attributes {
                    if attribute.key == AuthUserAttributeKey.name {
                        firstName = attribute.value
                    } else if attribute.key == AuthUserAttributeKey.familyName {
                        lastName = attribute.value
                    } else if attribute.key == AuthUserAttributeKey.email {
                        email = attribute.value
                    }
                }
                print("User attributes - \(attributes)")
                print("Name: \(firstName) \(lastName)")
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }

        print("Inside the createUserRecordFunction")
        
        let newUser = User(sub: sub, username: userName, bio: bio, totalDistance: totalDistance, runningStatus: runningStatus, friends: friends, blockedUsers: blockedUsers, email: email, createdAt: createdAt, updatedAt: updatedAt)
        
        print(newUser)
        
        Amplify.DataStore.save(newUser) { result in
            switch result {
            case .success(_):
                print("Saved")
                self.currentUser = newUser
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
                    self.currentUser = nil
                    self.emergencyContacts.removeAll()
                    self.deviceTracking = nil
                    print("Local data cleared successfully.")
                    Amplify.DataStore.stop { (result) in
                            switch(result) {
                            case .success:
                                Amplify.DataStore.start { (result) in
                                    switch(result) {
                                    case .success:
                                        print("DataStore started")
                                    case .failure(let error):
                                        print("Error starting DataStore:\(error)")
                                    }
                                }
                            case .failure(let error):
                                print("Error stopping DataStore:\(error)")
                            }
                        }
                case .failure(let error):
                    print("Local data not cleared \(error)")
                }
            }
        }
    }
    
    func getEmergencyContacts() {
        if self.currentUser == nil {
            if let user = Amplify.Auth.getCurrentUser() {
                Task() {
                    do {
                        try await getUserProfile(user: user)
                    } catch {
                        print("ERROR IN GET EMERGENCY CONTACT FUNCTION")
                    }
                }
                
            }
        } else {
            let emergencyKeys = EmergencyContact.keys
            print("inside emergency contacts database call")
            Amplify.DataStore.query(EmergencyContact.self, where: emergencyKeys.userID == currentUser?.id) { result in
                print("OUTSIDE THE SWITCH OF GET EMERGENCY CONTACT")
                switch(result) {
                case .success(let items):
                    print("CHECK THIS ^^^^^")
                    self.emergencyContacts = items
                    
                case .failure(let error):
                    print("Could not query DataStore: \(error)")
                }
            }
        }
    }


    func getNotifications() async {
        print("STARTING THE GET NOTIFICATION FUNCTION")
        if self.currentUser == nil {
            if let user = Amplify.Auth.getCurrentUser() {
                Task () {
                    do {
                        try await getUserProfile(user: user)
                    } catch {
                        print ("")
                    }
                }
            }
        } else {
            let keys = Notification.keys
            Amplify.DataStore.query(Notification.self, where: keys.receiverId == currentUser!.id) { result in
                switch(result) {
                case .success(let items):
                    print("*()*()*")
                    self.notifications = items
                case .failure(let error):
                    print("Could not query DataStore: \(error)")
                }
            }
        }
    }

    func createEmergencyContactRecord(contact: EmergencyContact) {
        print("INSIDE THE CREATE EMERGENCY CONTACT RECORD!")
        print("RECORD TRYING TO SAVE: \(contact)")
        Amplify.DataStore.save(contact) { result in
            switch result {
            case .success(_):
                print("Saved")
                DispatchQueue.main.async {
                    print(self.emergencyContacts.append(contact))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createEmergencyContactRecord ( firstName: String,
                                        lastName: String,
                                        searchVal: String,
                                        phoneNumber: String ){
        
//        var user: User?
//        var user1: User?
        var userRecord: User?
        Task() {
                do {
                    var user = try await getUserRecordEmailSearch(email: searchVal)
//                    try await user1 = getUserRecordUsernameSearch(username: searchVal)
                    if user == nil {
                        user = try await getUserRecordUsernameSearch(username: searchVal)
                    }
                    if user == nil {
                        let contact = EmergencyContact (firstName: firstName, lastName: lastName, email: searchVal, phoneNumber: phoneNumber, appUser: false, userID: currentUser?.id ?? "0000")
                        print("THIS IS THE EMERGENCY CONTACT WHEN USER == NIL :  \(contact)")
                        createEmergencyContactRecord(contact: contact)
                    } else {
                        let contact = EmergencyContact (firstName: firstName, lastName: lastName, email: user?.email ?? "ERROR@ERROR.com".lowercased(), phoneNumber: phoneNumber, appUser: true, emergencyContactUserId: user?.id ?? "0000", userID: currentUser?.id ?? "0000", emergencyContactAppUsername: user?.username ?? "ERROR")
                        print("THIS IS THE EMERGENCY CONTACT WHEN USER != NIL : \(contact)")
                        createEmergencyContactRecord(contact: contact)
                    }
                } catch {
                    print("ERROR IN CREATE EMERGENCY CONTACT RECORD!")
                }
        }
    }
    
    func getUserRecordEmailSearch (email: String) async -> User? {
        let usrKey = User.keys
        var retVal: User?
        await Amplify.DataStore.query(User.self, where: usrKey.email == email.lowercased()) { result in
            print("RESULT INSIDE GET USER RECORD FUNCTION WITH EMAIL: \(result)")
            switch(result) {
            case .success(let items):
                if items.count > 1 {
                    print("ERROR --- More than 1 user record exists when looking up with the email address, using first one found")
                    retVal = items[0]
                } else {
                    for item in items {
                        print("CHECK THIS ****")
                        print("User ID: \(item.id)")
                        print("This is the item: \(item)")
                        retVal = item
                    }
                }
                if items.isEmpty {
                    print("NO USER RECORD FOUND WITH EMAIL LOOKUP")
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return retVal
    }
    
    func getUserRecordUsernameSearch (username: String) async -> User? {
        let usrKey = User.keys
        var retVal: User?
        await Amplify.DataStore.query(User.self, where: usrKey.username == username.lowercased()) { result in
            print("RESULT INSIDE GET USER RECORD FUNCTION WITH USERNAME: \(result)")
            switch(result) {
            case .success(let items):
                if items.count > 1 {
                    print("ERROR --- More than 1 user record exists when looking up with the email address, using first one found")
                    retVal = items[0]
                } else {
                    for item in items {
                        print("CHECK THIS $$$$$$")
                        print("User ID: \(item.id)")
                        print("This is the item: \(item)")
                        retVal = item
                    }
                }
                if items.isEmpty {
                    print("NO USER RECORD FOUND WITH USERNAME LOOKUP")
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return retVal
    }
    

    func getRunnerRecords() {
        if self.currentUser == nil {
            if let user = Amplify.Auth.getCurrentUser() {
                Task() {
                    do {
                        try await getUserProfile(user: user)
                    } catch {
                        print("ERROR IN GET EMERGENCY CONTACT FUNCTION")
                    }
                }
            }
        } else {
            let keys = EmergencyContact.keys
            Amplify.DataStore.query(EmergencyContact.self, where: keys.emergencyContactUserId == currentUser?.id) { result in
                switch(result) {
                case .success(let items):
                    print("INSIDE THE GET RUNNER RECORDS FUNCTION")
                    self.runners = items
                case .failure(let error):
                    print("Could not query DataStore: \(error)")
                }
            }
        }
        
    }
    
    func checkIfRunning(userID: String) -> Bool {
        return (getUserProfile(userID: userID)?.runningStatus != RunningStatus.notrunning) && (getUserProfile(userID: userID)?.runningStatus != nil)
    }
    
    func deleteEmergencyContact(contactId: String) {
        Amplify.DataStore.delete(EmergencyContact.self, withId: contactId) { result in
            switch result {
            case .success:
                print("Emergency Contact deleted!")
            case .failure(let error):
                print("Error deleting Emergency Contact - \(error.localizedDescription)")
            }
        }
    }
    
    func updateEmergencyContact(contact: EmergencyContact) {
        
    }
}
