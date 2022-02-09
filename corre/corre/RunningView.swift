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
    
    func getCurrentUserLocation() {
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
