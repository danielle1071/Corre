//
//  ConnectionProvider.swift
//  corre
//
//  Created by Lucas Morehouse on 4/6/22.
//

import UIKit
import WatchConnectivity

class ConnectionProvider: NSObject, WCSessionDelegate, ObservableObject {
    
    private let session : WCSession
    @Published var controller : WatchController
    var lastMessage : CFAbsoluteTime = 0
    
    
    init(session : WCSession = .default) {
        self.session = session
        self.controller = WatchController()
        super.init()
        self.session.delegate = self
        
        #if os(iOS)
        print("Connection provider initialized on phone")
        #endif
        
        #if os(watchOS)
        print("Connection provider initialized on watch")
        #endif
        
        self.connect()
        
    }
    
    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
        
        session.activate()
    }
    
    func send(message: [String : Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func sendStateUpdate() {
        NSKeyedArchiver.setClassName("Controller", for: WatchController.self)
        let vState = try! NSKeyedArchiver.archivedData(withRootObject: controller)
        sendWatchMessage(vState)
    }
    
    func sendWatchMessage(_ msgData : Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        if session.isReachable {
            print("Sending Watch Message")
            let message = ["Controller" : msgData]
            session.sendMessage(message, replyHandler: nil)
        }
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    #endif

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Inside the Did Receive Message Function -- ConnectionProvider")
        
        if message["Controller"] != nil {
            let loadedData = message["Controller"]
            
            print("Controller no reply handler")
            
            NSKeyedUnarchiver.setClass(WatchController.self, forClassName: "Controller")
            
            let loadedPerson = try! NSKeyedUnarchiver.unarchivedObject(ofClass: WatchController.self, from: loadedData as! Data) as? WatchController
            
            self.controller = loadedPerson!
        }
        
    }
    
}
