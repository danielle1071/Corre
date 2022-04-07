//
//  WatchController.swift
//  corre
//
//  Created by Lucas Morehouse on 4/6/22.
//

import UIKit

//MARK: String Definitions Since enums can't be encoded!
//MARK: Landing  === 0
//MARK: Dashboard === 1

public class WatchController: NSObject, ObservableObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let id = UUID()
    @Published var currentState : String = ""
    @Published var usrID : String = ""
    
    
    public required convenience init?(coder: NSCoder) {
        guard let loggedIn = coder.decodeObject(forKey: "state") as? String,
                let usrID = coder.decodeObject(forKey: "usrID") as? String
        else { return nil }
        self.init()
        self.setState(currentState: loggedIn)
        self.setUsrID(id: usrID)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.currentState, forKey: "state")
        coder.encode(self.usrID, forKey: "usrID")
    }
    
    func setState(currentState: String) {
        self.currentState = currentState
    }
    
    func setUsrID(id: String) {
        self.usrID = id
    }

}
