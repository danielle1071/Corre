//
//  TrackRunnerView.swift
//  corre
//
//  Created by Lucas Morehouse on 2/13/22.
//

import SwiftUI
import Foundation
import Amplify
import Combine
import AmplifyMapLibreUI

struct TrackRunnerView: View {
    
    
    @EnvironmentObject var sessionManager: SessionManger
    @StateObject var trackingManager = TrackerManager()
    var userTrackingID: String
    @State var mapState = AMLMapViewState()
    @State var tokens: Set<AnyCancellable> = .init()
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) {_ in
            VStack {
                Button("Back", action: sessionManager.showSession)

                Text("xCord: \(trackingManager.xCord)")
                Text("yCord: \(trackingManager.yCord)")
                
                Button("track!", action: {
                    trackingManager.startTracking()
                })
                
                Text("Tracking : \(trackingManager.tString)")

                
            }
        }.onAppear(perform: {
            trackingManager.setSessionManager(sessionManager: sessionManager)
            trackingManager.setTrackingID(userTrackID: userTrackingID)
        })
    }

    struct TrackRunnerView_Previews: PreviewProvider {
        static var previews: some View {
            Text("Hello World!")
        }
    }
}
