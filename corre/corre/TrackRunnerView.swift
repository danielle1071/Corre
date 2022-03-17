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
    
    // test2
    
    @EnvironmentObject var sessionManager: SessionManger
    @StateObject var trackingManager = TrackerManager()
    
    var userTrackingID: String
    
    @State var mapState = AMLMapViewState(zoomLevel: 17)
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
                ZStack {
                    // AMLMapView(mapState: mapState)
                    //    .edgesIgnoringSafeArea(.all)
                    //    .overlay(Text("📍"), alignment: .center)
                    AMLMapView(mapState: mapState)
                        .overlay(Text("📍"), alignment: .center)
                        .frame(width: /*@START_MENU_TOKEN@*/350.0/*@END_MENU_TOKEN@*/, height: 550)
                        .cornerRadius(20)
                        .edgesIgnoringSafeArea(.all)
                        .shadow(radius: 2)
                }

            }
            
            
        }
        .onAppear(perform: {
            trackingManager.setSessionManager(sessionManager: sessionManager)
            trackingManager.setTrackingID(userTrackID: userTrackingID)
            getRunnerLocation()
        })
    
    }
    
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
