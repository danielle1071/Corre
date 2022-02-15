//
//  TrackerManager.swift
//  corre
//
//  Created by Lucas Morehouse on 2/15/22.
//

import Foundation
import Amplify
import Combine
import CoreLocation
import SwiftUI


class TrackerManager: ObservableObject {
    
    
    @Published var xCord = 0.0
    @Published var yCord = 0.0
    var sessionManager: SessionManger?
    var timer: Timer?
    var trackUser: User?
    var device: Device?
    var userTrackID: String?
    @Published var tracking = false
    @Published var tString = ""
    
    
    func setSessionManager(sessionManager: SessionManger) {
        self.sessionManager = sessionManager
    }
    func setTrackingID(userTrackID: String) {
        self.userTrackID = userTrackID
    }
    func startTracking() {
        if userTrackID == nil {
            print("ERROR --- userTrackID not assigned! startTracking function")
            return
        }
        if sessionManager == nil {
            print("ERROR --- SessionManger not initialized! startTracking funciton")
            return
        }
        trackUser = sessionManager!.databaseManager.getUserProfile(userID: self.userTrackID!)
        if trackUser == nil {
            print("ERROR --- couldn't find user to track --- startTracking function")
            return
        }
        device = sessionManager!.databaseManager.findDeviceRecord(userDeviceID: self.userTrackID!)
        if device == nil {
            print("ERROR --- couldn't find device to track --- startTracking function")
            return
        }
        self.tracking = self.trackUser!.runningStatus == .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: self.tracking, block: { _ in
                print("Tracking the user!")
                self.refresh()
                if !self.tracking {
                    print("NOT TRACKING!")
                    self.timer?.invalidate()
                }
            })
        print("DONE TRACKING USER!")
    }
    
    func refresh() {
        if device == nil {
            print("ERROR --- couldn't find device to track --- refresh function")
            return
        }
        if userTrackID == nil {
            print("ERROR --- userTrackID not assigned! refresh function")
            return
        }
        if self.xCord != self.device!.xCord || self.yCord != self.device!.yCord {
            DispatchQueue.main.async {
                self.xCord = self.device!.xCord ?? -1.0
                self.yCord = self.device!.yCord ?? -1.0
            }
        }
        device = sessionManager!.databaseManager.findDeviceRecord(userDeviceID: self.userTrackID!)
        trackUser = sessionManager!.databaseManager.getUserProfile(userID: self.userTrackID!)
        DispatchQueue.main.async {
            self.tracking = self.trackUser!.runningStatus == .running
            if self.tracking {
                self.tString = "True"
            } else {
                self.tString = "False"
            }
        }
    }
    
    
}
