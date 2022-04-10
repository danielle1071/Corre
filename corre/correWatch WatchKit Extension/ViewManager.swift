//
//  ViewManager.swift
//  correWatch WatchKit Extension
//
//  Created by Lucas Morehouse on 4/8/22.
//

import Foundation
import Combine

enum Views {
    case landing
    case dashboard
    case selectContact(runManager: RunningManager)
    case running
    case error
}

class ViewManager: ObservableObject {
    
    @Published var currentView : Views = .landing
    
    func setDashboard() {
        DispatchQueue.main.async {
            self.currentView = .dashboard
        }
    }
    
    func setSelectRunner(runManager: RunningManager) {
        DispatchQueue.main.async {
            self.currentView = .selectContact(runManager: runManager)
        }
    }
    
    func setLanding() {
        DispatchQueue.main.async {
            self.currentView = .landing
        }
    }
}
