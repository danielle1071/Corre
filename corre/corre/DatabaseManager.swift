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
    var DEBUG = true
    
    @Published var currentUser:User?
    
    @Published var emergencyContacts = [EmergencyContact]()
    
    @Published var deviceTracking:Device?
    
    @Published var runners = [EmergencyContact]()
    
    @Published var runs = [Run]()

    @Published var notifications = [Notification]()

    @Published var friends = [User]()

    var subscriptions = Set<AnyCancellable>()
    
    var updateEmail = ""
    
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
                    if self.currentUser != nil && (self.currentUser!.email == nil || self.currentUser!.email! == "donotemail@error.com") {
                        fixProfileEmail()
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
    
    
    func getUserProfile(username: String) -> User? {
        var returnVal: User? = nil
        let keys = User.keys
        Amplify.DataStore.query(User.self, where: keys.username == username) { result in
            switch(result) {
            case .success(let items):
                if items.count > 1 {
                    print("More than 1 user found")
                }
                if items.count < 1 {
                    print("No record found")
                } else {
                    returnVal = items[0]
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return returnVal
    }
    
    func getUserProfile(email: String) -> User? {
        var returnVal: User? = nil
        let keys = User.keys
        Amplify.DataStore.query(User.self, where: keys.email == email) { result in
            switch(result) {
            case .success(let items):
                if items.count > 1 {
                    print("More than 1 user found")
                }
                if items.count < 1 {
                    print("No record found")
                } else {
                    returnVal = items[0]
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return returnVal
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
                let newUser = User(sub: sub, username: userName, bio: bio, totalDistance: totalDistance, runningStatus: runningStatus, friends: friends, blockedUsers: blockedUsers, email: email, createdAt: createdAt, updatedAt: updatedAt)
                
                print(newUser)
                
                Amplify.DataStore.save(newUser) { result in
                    switch result {
                    case .success(_):
                        print("Saved new user record!")
                        self.currentUser = newUser
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }

        print("Finished the createUserRecordFunction")
        
        
        
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
                    self.runs.removeAll()
                    print("Local data cleared successfully.")
                    Amplify.DataStore.stop { (result) in
                            switch(result) {
                            case .success:
                                DispatchQueue.main.async {
                                    Amplify.DataStore.start { (result) in
                                        switch(result) {
                                        case .success:
                                            print("DataStore started")
                                        case .failure(let error):
                                            print("Error starting DataStore:\(error)")
                                        }
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
    
    func getUserRunLogs() {
        if (DEBUG) { print("DatabaseManager -> getUserRunLogs ") }
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
            let keys = Run.keys
            Amplify.DataStore.query(Run.self, where: keys.userID == currentUser!.id) { result in
                switch(result) {
                case .success(let items):
                    self.runs = items
                    if (DEBUG) {
                        print("DatabaseManager -> getUserRunLogs -> successful query")
                        print("Runs: \(runs)")
                    }
                    
                case .failure(let error):
                    print("DatabaseManager -> getUserRunLogs -> Could not query DataStore: \(error)")
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
            case .success(let resultItem):
                print("Saved \(resultItem)")
//                DispatchQueue.main.async {
//                    print(self.emergencyContacts.append(contact))
//                }
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
                        let contact = EmergencyContact (firstName: firstName, lastName: lastName, email: user?.email ?? "ERROR@ERROR.com".lowercased(), phoneNumber: phoneNumber, appUser: true, emergencyContactUserId: user?.id ?? "0000", emergencyContactAppUsername: user?.username ?? "ERROR", userID: currentUser?.id ?? "0000")
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
    
    func startRunNotification(id: String) {
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
        }
        
        //MARK: Why don't we utilize the userID - this would allow
        //MARK: For a fast query instead of a slow scan?
        
        let receiver = getUserProfile(userID: id)
        
        if (receiver != nil) {
            let notification = Notification(
                //MARK: This sender ID should be the current user id - not username
                senderId: self.currentUser!.id,
//                senderId: self.currentUser!.username,
                receiverId: receiver!.id,
                type: NotificationType.runnerstarted)
            
            if (DEBUG) { print("DatabaseManager -> startRunNotification -> \(receiver)")}
            
            createNotificationRecord(notification: notification)
        }
    }
    
    //MARK: See above comments made about startRunNotification function 
    func endRunNotification(id: String) {
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
        }
        
        let receiver = getUserProfile(userID: id)
        
        if (receiver != nil) {
            let notification = Notification(
                senderId: self.currentUser!.id,
                receiverId: receiver!.id,
                type: NotificationType.runnerended)
            
            if (DEBUG) { print("DatabaseManager -> endRunNotification -> \(receiver)")}
            
            createNotificationRecord(notification: notification)
        }
    }
    
    func runnerEventNotification(username: String) {
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
        }
        
        let receiver = getUserProfile(username: username)
        
        if (receiver != nil) {
            let notification = Notification(
                senderId: self.currentUser!.id,
                receiverId: receiver!.id,
                type: NotificationType.runevent)
            
            if (DEBUG) { print("DatabaseManager -> runnerEventNotification -> \(receiver)")}
            
            createNotificationRecord(notification: notification)
        }
    }
    
    func saveUserRunLog(distance: Double,
                        time: String,
                        averageSpeed: Double) {
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
        }
        
        if (self.currentUser != nil) {
            
            let run = Run(
                distance: distance,
                // time: time,
                averageSpeed: averageSpeed,
                userID: self.currentUser!.id)
            
            if (DEBUG) { print("DatabaseManager -> saveUserRunLog -> \(run)")}
            
            createRunRecord(run: run)
        }
    }
    
    func createRunRecord(run: Run) {
        
        Amplify.DataStore.save(run) { result in
            switch result {
            case .success(let item):
                print("DatabaseManager -> createRunRecord -> Saved Run Record")
            case .failure(let error):
                print("DatabaseManager -> createRunRecord -> Error on Run Record \(error.localizedDescription)")
            }
        }
    }
    
    func createNotificationRecord(notification: Notification) {
        Amplify.DataStore.save(notification) { result in
            switch result {
            case .success(_):
                print("Saved Notification Record")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func friendRequest(username: String) {
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
        }
        let receiver = getUserProfile(username: username)
        if receiver != nil && !checkAlreadyFriends(user: receiver!, currentID: currentUser!.id) && !checkBlocked(user: receiver!, currentID: currentUser!.id) {
            let notification = Notification(senderId: self.currentUser!.id, receiverId: receiver!.id, type: NotificationType.friendrequest)
            createNotificationRecord(notification: notification)
        }
    }
    
    func checkFriendRequestExist(username: String) -> Bool {
        var retVal = false
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
        }
        let receiver = getUserProfile(username: username)
        if receiver != nil {
            let notificationKeys = Notification.keys
            // check if the current user has already sent a friend request
            Amplify.DataStore.query(Notification.self, where: notificationKeys.senderId == currentUser!.id && notificationKeys.receiverId == receiver!.id && notificationKeys.type == NotificationType.friendrequest) { result in
                switch result {
                case .success(let items):
                    retVal = items.count > 0
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            // check if the current user has received a friend request
            Amplify.DataStore.query(Notification.self, where: notificationKeys.senderId == receiver!.id && notificationKeys.receiverId == currentUser!.id && notificationKeys.type == NotificationType.friendrequest) { result in
                switch result {
                case .success(let items):
                    if items.count == 1 {
                        // Treat as accept friend request!
                        addFriendToList(user1: receiver!, user2: currentUser!)
                        deleteNotificationRecord(notification: items[0])
                        retVal = false
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        return retVal
    }
    
    
    func deleteNotificationRecord(notification: Notification) {
        Amplify.DataStore.delete(notification) { result in
            switch result {
            case .success(_):
                print("Deleted Notification Record")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        Task() {
            do {
                try await getNotifications()
            } catch {
                print("ERROR INSIDE ACCEPT EMERGENCY CONTACT!")
            }
        }
    }
    
    func acceptedFriendRequest(notification: Notification, userId: String){
        addFriendToList(userId: userId)
        deleteNotificationRecord(notification: notification)
    }
    
    
    func checkAlreadyFriends(user: User, currentID: String) -> Bool {
        let friendList = user.friends
        return friendList?.contains(currentID) ?? false
    }
    
    func checkBlocked(user: User, currentID: String) -> Bool {
        let blockedList = user.blockedUsers
        return blockedList?.contains(currentID) ?? false
    }
    
    //MARK: Need to add an array initialization here for the friends
    //MARK: Array if it is nil -LM
    func addFriendToList(userId: String) {
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
        }
        var user1 = self.currentUser
        var user2 = getUserProfile(userID: userId)
        if user2 != nil {
            if user1!.friends == nil {
                user1!.friends = [String?]()
            }
            if user2!.friends == nil {
                user2!.friends = [String?]()
            }
            
            //currentUser?.friends?.append(user2?.id)
            user1?.friends?.append(user2?.id)
            user2?.friends?.append(user1?.id)
            
            Amplify.DataStore.save(user1!) { result in
                switch result {
                case .success(_):
                    print("Saved")
                    self.currentUser = user1
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            Amplify.DataStore.save(user2!) { result in
                switch result {
                case .success(_):
                    print("Saved")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func removeFriendFromArray(userId: String) {
        var user1 = currentUser
        var user2 = getUserProfile(userID: userId)
        var flag1 = false
        var flag2 = false
        var index1 = 0
        var index2 = 0
        //used size because swift was causing problems with the for in loop -- we can refactor later on
        var size1 = user1?.friends?.endIndex ?? -1
        var size2 = user2?.friends?.endIndex ?? -1
        size1 = size1 - 1 //endIndex returns 1+ the size, so we subtract 1
        size2 = size2 - 1
        //traverse array to find index of friend
        if size1 == -2 {
            //error getting size of array
        }
        for i in 0...size1 {
            if user1?.friends?[i] == user2?.id {
                flag1 = true
                index1 = i
                break
            }
        }
        if flag1 == false {
            //friend was not found
        } else {
            print("Deleting index1!")
            //remove from index and re-index array
            user1?.friends?.remove(at: index1)
        }
        //removed from user1 list, now to user2...
        if size2 == -2 {
            //error getting size of array
        }
        for i in 0...size2 {
            if user2?.friends?[i] == user1?.id {
                flag2 = true
                index2 = i
                break
            }
        }
        if flag2 == false {
            //friend was not found
        } else {
            print("Deleting index2!")
            user2?.friends?.remove(at: index2)
        }
        
        
        
        
//        DispatchQueue.main.async {
            
        
        
            Amplify.DataStore.save(user2!) { result in
                switch (result){
                case .success:
                    print("SUCCES")
                case .failure(let error):
                    print(error.localizedDescription);
                }
            }
            Amplify.DataStore.save(user1!) { result in
                switch (result){
                case .success:
                    print("SUCCES")
                case .failure(let error):
                    print(error.localizedDescription);
                }
            }
            
            self.getFriends()
//        }
    }
    
    
    func blockUser(username: String) {
        //TODO: Create function to allow a user to block another user
    }
    
    func addFriendToList(user1: User, user2: User) {
        var user1Updated = user1
        var user2Updated = user2
        
        if user1Updated.friends == nil {
            user1Updated.friends = [String?]()
        }
        if user2Updated.friends == nil {
            user2Updated.friends = [String?]()
        }
        user1Updated.friends!.append(user2.id)
        user2Updated.friends!.append(user1.id)
        Amplify.DataStore.save(user1Updated) { result in
            switch (result) {
            case .success(_):
                print("Saved friend in add friend to list - user1")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        Amplify.DataStore.save(user2Updated) { result in
            switch (result) {
            case .success(_):
                print("Saved friend in add friend to list - user2")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func getFriends() {
        if self.currentUser == nil {
            if let user = Amplify.Auth.getCurrentUser() {
                Task() {
                    do {
                        try await getUserProfile(user: user)
                    } catch {
                        print("ERROR IN GET FRIENDS CONTACT FUNCTION")
                    }
                }
            }
        } else {
            self.currentUser = self.getUserProfile(userID: self.currentUser!.id)
        }
        
        /*
        var count = 0

        if (currentUser != nil && currentUser!.friends != nil) {
            let count = currentUser!.friends!.count
        }
        */
        
        let count = currentUser!.friends?.count ?? 0
       
        print("DatabaseManager -> getFriends -> friend count: \(count)")
        
        let usrKeys = User.keys
        var retArr = [User]()
        for index in 0...count {
            if index < count {
                print("This is index: \(index)")
                if let frien = self.getUserProfile(userID: self.currentUser!.friends![index]!) {
                    retArr.append(frien)
                    
                    print("DatabaseManager -> getFriends -> \(frien)")
                }
            }
        }
        self.friends = retArr
    }
    
    func getFriendRequestsSent() -> [Notification] {
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
        }
        var requests = [Notification]()
        let notificationKeys = Notification.keys
        Amplify.DataStore.query(Notification.self, where: notificationKeys.senderId == currentUser!.id && notificationKeys.type == NotificationType.friendrequest) { result in
            switch (result) {
            case .success (let items):
                requests = items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        print("THIS IS REQUESTS: \(requests)")
        return requests
    }
    
    
  
    func deleteEmergencyContact(contactId: String) {
        Amplify.DataStore.delete(EmergencyContact.self, withId: contactId) { result in
            switch result {
            case .success:
                print("Emergency Contact deleted!")
                self.getEmergencyContacts()
            case .failure(let error):
                print("Error deleting Emergency Contact - \(error.localizedDescription)")
            }
        }
    }
    
    func updateEmergencyContact(contact: EmergencyContact) {
        print("INSIDE THE UPDATE EMERGENCY CONTACT!")
        Amplify.DataStore.save(contact) { result in
            switch result {
            case .success(_):
                print("Updated the contact")
                self.getEmergencyContacts()

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    func resetPassword(email: String) { //we can use username or passwork -> check during call
        Amplify.Auth.resetPassword(for: email) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code sent to - \(deliveryDetails) \(info)")
                case .done:
                    print("Reset completed")
                }
            } catch {
                print("Reset password failed with error \(error)")
            }
        }
    }
    
    func confirmResetPassword(
        email: String,
        newPassword: String,
        confirmationCode: String
    ) {
        Amplify.Auth.confirmResetPassword(
            for: email,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { result in
            switch result {
            case .success:
                print("Password reset confirmed")
            case .failure(let error):
                print("Reset password failed with error \(error)")
            }
        }
    }

      
    func checkUserExists(email: String) -> Bool {
        var retVal = false
        Amplify.DataStore.query(User.self, where: User.keys.email == email.lowercased()) { result in
            switch result {
            case .success(let items):
                retVal = items.count > 0
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        Amplify.DataStore.clear() { result in
            switch result {
            case .success:
                print("inside check usr exist")
                Amplify.DataStore.start(){ result in
                    switch result {
                    case .success:
                        print("inside check usr exist")
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        print("Finishing checkUserExists and exiting with \(retVal)")
        return retVal
    }
    
    func fixProfileEmail() {
        
        var updateUsr = currentUser!
        
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                for attribute in attributes {
                    if attribute.key == AuthUserAttributeKey.name {
                        print("FirstName : \(attribute.value)")
                    } else if attribute.key == AuthUserAttributeKey.familyName {
                        print("LastName : \(attribute.value)")
                    } else if attribute.key == AuthUserAttributeKey.email {
                        print("Email : \(attribute.value)")
                        updateUsr.email = attribute.value
                        print("This is the updated value \(updateUsr.email)")
                        self.updateUserProfile(updatedUser: updateUsr)
                    }
                }
                print("User attributes - \(attributes)")
                
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }
        
    }
    
    func updateUserProfile(updatedUser: User) {
        Amplify.DataStore.save(updatedUser) { result in
            switch (result) {
            case .success(let result):
                print("Result: \(result)")
                print("Profile updated \(updatedUser)")
                self.currentUser = result
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sendEmergencyContactRequest(user: User, firstName: String, lastName: String, phoneNumber: String) {
        if currentUser == nil {
            print("ERROR -- no user loaded --> sendEmergencyContactRequest currentUser = \(currentUser) --- Exiting function without sending request")
            return
        }
        let emgContacts = self.getEmergencyContacts()
        // ensuring the current user hasn't been blocked by the requester
        if user.blockedUsers != nil && user.blockedUsers!.contains(currentUser!.id) {
            print("Curent user is blocked by requester -- exiting")
            return
        }
        for contact in self.emergencyContacts {
            if contact.appUser != nil && contact.appUser!  && contact.emergencyContactUserId == user.id {
                return
            }
        }
        
        let requestExist = checkEmergencyRequest(id: user.id)
        if !requestExist {
            let contactInfo = "[{\"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"phoneNumber\": \"\(phoneNumber)\"}]"
            
            let notification = Notification(senderId: currentUser!.id, receiverId: user.id,body: contactInfo, type: NotificationType.emergencycontactrequest)
            self.createNotificationRecord(notification: notification)
        } else {
            print("ERROR -- request already exists!")
        }
    }
    
    func acceptEmergencyContactRequest(notification: Notification) {
        //MARK: USE THIS LATER -LM
        if notification.body == nil {
            print("EXITING EARLY")
            return
        } else {
            print("THIS IS THE NOTIFICATION!!!")
        }
        let contactInfo = notification.body!
        let data = contactInfo.data(using: .utf8)!
        
        var firstNameEM = ""
        var lastNameEM = ""
        var phoneNumberEM = ""
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                print("HERE !@#$%")
               print(jsonArray) // use the json here
                for items in jsonArray {
                    if let phoneNumberPrint = items["phoneNumber"] as? String {
                        print("Here is phoneNumber: \(phoneNumberPrint)")
                        phoneNumberEM = phoneNumberPrint
                    }
                    if let firstNamePrint = items["firstName"] as? String {
                        print("Here is firstName: \(firstNamePrint)")
                        firstNameEM = firstNamePrint
                    }
                    if let lastNamePrint = items["lastName"] as? String {
                        print("Here is lastName: \(lastNamePrint)")
                        lastNameEM = lastNamePrint
                    }
                    
                    print("This is the item \(items)")
                }
                
                
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print("HERE )(*&^")
            print(error)
        }
        let user = self.getUserProfile(userID: notification.senderId)
        if user != nil && currentUser != nil {
            print("LOOK AT THE USER DETAILS \(user!)")
            let contact = EmergencyContact(firstName: firstNameEM, lastName: lastNameEM, email: currentUser!.email!, phoneNumber: phoneNumberEM, appUser: true, emergencyContactUserId: currentUser!.id, emergencyContactAppUsername: currentUser!.username, userID: user!.id)
            print("Sending \(contact) to the createEmergencyConactRecord")
            self.createEmergencyContactRecord(contact: contact)
            deleteNotificationRecord(notification: notification)
            self.getRunnerRecords()
        } else {
            print("Either user or currentUser === nil --> sender: \(user) | ---> currentUser: \(currentUser)")
            return
        }
        
    }
    
    func declineEmergencyContactRequest(notification: Notification) {
        deleteNotificationRecord(notification: notification)
    }
    
    func checkEmergencyRequest(id: String) -> Bool {
        let keys = Notification.keys
        var retVal = false
        Amplify.DataStore.query(Notification.self, where: keys.senderId == currentUser!.id && keys.receiverId == id && keys.type == NotificationType.emergencycontactrequest) { result in
            switch(result) {
            case .success(let item):
                retVal = item.count > 0
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return retVal
    }

}
