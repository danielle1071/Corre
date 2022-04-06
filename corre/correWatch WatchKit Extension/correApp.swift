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
    
    init() {
        connector.connect()
        
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            switch connector.controller.currentState {
            case .landing:
                LandingPageView()
                    .environmentObject(connector)
            case .loggedIn:
                DashboardView()
                    .environmentObject(connector)
            }
             
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
