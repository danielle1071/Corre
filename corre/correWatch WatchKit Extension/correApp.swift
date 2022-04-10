//
//  correApp.swift
//  correWatch WatchKit Extension
//
//  Created by Lauren Wright on 2/26/22.
//

import SwiftUI

@main
struct correApp: App {
    
    @ObservedObject var connector = ConnectionProvider()
    @ObservedObject var viewManager = ViewManager()
    init() {
        connector.connect()
        
            if self.connector.controller.currentState == "1" {
                self.viewManager.setDashboard()
            }
            
        
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            switch viewManager.currentView {
            case .landing:
                LandingPageView()
                    .environmentObject(connector)
                    .environmentObject(viewManager)
            case .dashboard:
                DashboardView()
                    .environmentObject(connector)
                    .environmentObject(viewManager)
            case .selectContact(let manager):
                SelectContactView(runMan: manager)
                    .environmentObject(connector)
                    .environmentObject(viewManager)
            case .running:
                RunningView()
//                    .environmentObject(connector)
            case .error:
                ErrorView()
//                    .environmentObject(connector)
                    
            default:
                LandingPageView()
                    .environmentObject(connector)
                    .environmentObject(viewManager)
            }
             
        }

//        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
