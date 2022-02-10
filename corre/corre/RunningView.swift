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
    
    @State var mapState = AMLMapViewState()
    @StateObject var locationService = LocationManager()
    
    // LocationManager(sessionManager: sessionManager)
    @State var tokens: Set<AnyCancellable> = .init()
    
    // is this needed? = step 3 from Set up Core Location services - Tracker Documentation
    // let locationManager = LocationManager()
    
    var body: some View {
        
        VStack {
            
            Button("Back", action: {
                sessionManager.showSession()
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
    
    // User's Coordinates:  CLLocationCoordinate2D(latitude: 35.7020691, longitude: 139.7753269)
    // locationManager - got locations: [<+35.70206910,+139.77532690> +/- 5.00m (speed -1.00 mps / course -1.00) @ 2/9/22, 1:27:34 AM Eastern Standard Time]
    
    func getCurrentUserLocation() {
        if !sessionManager.databaseManager.currentUser.isEmpty {
            locationService.test(id: sessionManager.databaseManager.currentUser[0].username)
        }
        
        locationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { coordinates in
                print("User's Coordinates: ", coordinates)
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
