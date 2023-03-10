//
//  EmergContactRunningView.swift
//  corre
//
//  Created by Jon Abrigo on 2/13/22.
//
//
//  EmergContactView.swift
//  corre
//  Skeleton
//  Created by Mariana Botero on 2/7/22.
//
//  SwiftUIView.swift
//  Profile-page
//
//  Created by Danielle Nau on 2/8/22.
//
//  Adapted by Lucas Morehouse on 2/10/22.
//

//import Foundation
//import SwiftUI
//import Amplify
//import Combine

import SwiftUI
import Foundation
import Amplify
import Combine
import AmplifyMapLibreUI

struct EmergContactRunnningView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    @StateObject var locationService = LocationManager()
    @State var tokens: Set<AnyCancellable> = .init()
    @State var mapState = AMLMapViewState()
    
    let user: AuthUser
    
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
            Text("Tracking view")
            Spacer()
            
            Button("Sign Out", action: {
                sessionManager.signOut()
            })
        }
        .onAppear(perform: getRunnerLocation)
    }
    
    // MARK: deleteThis
    // User's Coordinates:  CLLocationCoordinate2D(latitude: 35.7020691, longitude: 139.7753269)
    // locationManager - got locations: [<+35.70206910,+139.77532690> +/- 5.00m (speed -1.00 mps / course -1.00) @ 2/9/22, 1:27:34 AM Eastern Standard Time]

    func getRunnerLocation() {
        
        locationService.storeUsername(id: "Database")
        
        locationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { coordinates in
                print("getCurrentUserLocation - user's Coordinates: ", coordinates)
                self.mapState.center = coordinates
            }
            .store(in: &tokens)
        
    }
    
    
//    @EnvironmentObject var sessionManager: SessionManger
//    @State var postsSubscription: AnyCancellable?
//    @State var users = [User]()
//    let user: AuthUser
//
//    var body: some View {
//        VStack {
//
//            // MARK: change this to stop run!
//            Button("Back", action: {
//                sessionManager.showSession()
//            })
//
//            List {
//                ForEach(users) { user in
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            Text(user.username)
//
//                            Spacer()
//                        }
//                        .frame(
//                            minWidth: 0,
//                            maxWidth: .infinity,
//                            minHeight: 180,
//                            maxHeight: 180,
//                            alignment: .center
//                        )
//
//                        Spacer()
//                    }
//                }
//            }
//            Spacer()
//
//        }.onAppear {
//            observeUsers()
//            queryUsers()
//        }
//    }
//
//
//    func queryUsers() {
//
//        let u = User.keys
//        Amplify.DataStore.query(User.self) {
//            result in
//            switch result {
//            case let .success(users):
//                self.users = users
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }
//
//    func observeUsers() {
//
//        postsSubscription = Amplify.DataStore.publisher(for: User.self)
//            .sink {
//                if case let .failure(error) = $0 {
//                    print("%%% Subscription received error - \(error.localizedDescription)")
//                }
//            }
//        receiveValue: { changes in
//            // handle incoming changes
//            print("%%% Subscription received mutation: \(changes)")
//            queryUsers()
//        }
//    }

}

//struct EmergContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmergContactView(user: AuthUser.self as! AuthUser)
//    }
//}
