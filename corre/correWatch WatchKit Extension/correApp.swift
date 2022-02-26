//
//  correApp.swift
//  correWatch WatchKit Extension
//
//  Created by Lauren Wright on 2/26/22.
//

import SwiftUI

@main
struct correApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
