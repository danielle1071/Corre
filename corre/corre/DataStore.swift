//
//  DataStore.swift
//  corre
//
//  Created by Lauren Wright on 2/8/22.
//  for friend view
//
//  Modified by Lucas Morehouse on 3.6.22

import Foundation
import SwiftUI
import Combine

struct Friend: Identifiable{
    var id = String()
    var friendItem = String()
}

class FriendStore: ObservableObject{
    @Published var friends = [Friend]()
}

struct emergContact: Identifiable {
    var id = String()
    var emergencyContact: EmergencyContact
}

class EmergencyContactStore: ObservableObject {
    @Published var emergencyContacts = [emergContact]()
}
