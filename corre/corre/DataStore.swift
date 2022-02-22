//
//  DataStore.swift
//  corre
//
//  Created by Lauren Wright on 2/8/22.
//  for friend view

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
