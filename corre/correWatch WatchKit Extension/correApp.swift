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
            case "0":
                LandingPageView()
                    .environmentObject(connector)
            case "1":
                DashboardView()
                    .environmentObject(connector)
            
            default:
                LandingPageView()
                    .environmentObject(connector)
            }
             
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
