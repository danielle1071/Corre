//
//  RunningView.swift
//  corre
//
//  Created by Mariana Botero on 2/7/22.
//

import SwiftUI
import Foundation
import Amplify
import Combine
import AmplifyMapLibreUI


struct RunningView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    @StateObject var locationService = LocationManager()
    @State var tokens: Set<AnyCancellable> = .init()
    @State var mapState = AMLMapViewState()
    
    var body: some View {
        
        VStack {
            
            // MARK: change this to stop run!
            Button("Back", action: {
                sessionManager.showSession()
                
                // stops tracker resources
                locationService.stopTracking()
            })
            
            Spacer()
            
            AMLMapView(mapState: mapState)
                .showUserLocation(true)
                .edgesIgnoringSafeArea(.all)
            
            
            Spacer()
            Text("🏃‍♀️ view")
            Spacer()
            
            Button("Sign Out", action: {
                sessionManager.signOut()
            })
        }
        .onAppear(perform: getCurrentUserLocation)
    }
    
    // MARK: deleteThis
    // User's Coordinates:  CLLocationCoordinate2D(latitude: 35.7020691, longitude: 139.7753269)
    // locationManager - got locations: [<+35.70206910,+139.77532690> +/- 5.00m (speed -1.00 mps / course -1.00) @ 2/9/22, 1:27:34 AM Eastern Standard Time]

    func getCurrentUserLocation() {
        
        if sessionManager.databaseManager.currentUser.isEmpty {
            print("getCurrentUserLocation - userName: nil")
            
            // MARK: need to transition to error page not session page
            sessionManager.showSession()
        }
        
        locationService.storeUsername(id: sessionManager.databaseManager.currentUser[0].username)
        
        locationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { coordinates in
                print("getCurrentUserLocation - user's Coordinates: ", coordinates)
                self.mapState.center = coordinates
            }
            .store(in: &tokens)
        
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView()
    }
}
