//
//  WatchController.swift
//  corre
//
//  Created by Lucas Morehouse on 4/6/22.
//

import UIKit

enum ViewState {
    case landing
    case loggedIn
}

public class WatchController: NSObject, ObservableObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let id = UUID()
    @Published var currentState : ViewState = .landing
    
    
    public required convenience init?(coder: NSCoder) {
        guard let loggedIn = coder.decodeObject(forKey: "state") as? ViewState
        else { return nil }
        self.init()
        self.setState(currentState: loggedIn)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.currentState, forKey: "state")
    }
    
    func setState(currentState: ViewState) {
        self.currentState = currentState
    }

}
