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
import CoreLocation

struct TrackRunnerView: View {
    
    
    @EnvironmentObject var sessionManager: SessionManger
    @StateObject var trackingManager = TrackerManager()
    
    var userTrackingID: String
    
    @State var mapState = AMLMapViewState()
    @State var tokens: Set<AnyCancellable> = .init()
    @State var timer: Timer?
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) {_ in
            
            VStack {
                Button("Back", action: sessionManager.showSession)
                
                Text("xCord: \(trackingManager.xCord)")
                Text("yCord: \(trackingManager.yCord)")
                Button("track!", action: {
                    // trackingManager.startTracking()
                    // getRunnerLocation()
                    // runnerX = trackingManager.xCord
                    // runnerY = trackingManager.yCord
                })
                Text("Tracking : \(trackingManager.tString)")
                
                
                Spacer()
                    .frame(height: 30)
                AMLMapView(mapState: mapState)
                    .edgesIgnoringSafeArea(.all)

            }
            
            
        }
        .onAppear(perform: {
            trackingManager.setSessionManager(sessionManager: sessionManager)
            trackingManager.setTrackingID(userTrackID: userTrackingID)
            getRunnerLocation()
        })
    
    }
    
    // User: backend - BBEE9936-B93A-45ED-9D41-454CC5A296AC
    // 28.543021
    // -81.173699
    
    func getRunnerLocation() {
            trackingManager.setSessionManager(sessionManager: sessionManager)
            trackingManager.setTrackingID(userTrackID: userTrackingID)
            trackingManager.startTracking()
        
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: trackingManager.tracking, block: { _ in
                    print("Updating Coordinates~!")
                    if !trackingManager.tracking {
                        print("NOT TRACKING! --- TrackRunnerView")
                        self.timer?.invalidate()
                    }
                
                print("getRunnerLocation - trackingManager latitude: ", trackingManager.xCord)
                print("getRunnerLocation - trackingManager longitude: ", trackingManager.yCord)

                var runnerCoordinates = CLLocationCoordinate2D(
                    latitude: trackingManager.xCord,
                    longitude: trackingManager.yCord)

                print("getRunnerLocation - latitude: ", runnerCoordinates.latitude)
                print("getRunnerLocation - longitude: ", runnerCoordinates.longitude)

                self.mapState.center = runnerCoordinates

                })
            print("No More Coordinate Updates")

        }

    struct TrackRunnerView_Previews: PreviewProvider {
        static var previews: some View {
            Text("Hello World!")
        }
    }
}
