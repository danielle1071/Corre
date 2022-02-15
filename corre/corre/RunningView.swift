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
    
//<<<<<<< HEAD
//=======
//    @State var busyWaiting: Bool = true
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }
    
//>>>>>>> 8d637eb231977b632cc5e55feb18cb9de61b328d
    var body: some View {
        
        VStack {
            
            // MARK: change this to stop run!
            HStack{
                Button("Back", action: {
                sessionManager.databaseManager.setRunStatus(status: .notrunning)
                sessionManager.showSession()
                
                // stops tracker resources
                locationService.stopTracking()
            })
                Button(action:{
                }, label: {
                    Text("Pause Run")
                        .fontWeight(.bold)
                        .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(Capsule())
                })
            }
            Spacer()
            
            AMLMapView(mapState: mapState)
                .showUserLocation(true)
                .edgesIgnoringSafeArea(.all)
            
            HStack{
                Text("Time Elapsed: 00:00:00")
            }
            .padding(/*@START_MENU_TOKEN@*/.trailing, 9.0/*@END_MENU_TOKEN@*/)
            .foregroundColor(Color("primaryColor"))
            
            Spacer()
            Text("🏃‍♀️ view")
            Spacer()
            HStack {
                Button(action:{}, label: {
                    Text("SOS")
                        .fontWeight(.bold)
                        .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .clipShape(Capsule())
                })
           
                Button(action: {
                    sessionManager.signOut()
                }, label: {
                    Text("Sign Out")
                        .fontWeight(.bold)
                        .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(Capsule())
                })
                
            } .padding(5.0)
        }
        .onAppear(perform: {
            locationService.setSessionManager(sessionManager: sessionManager)
            getCurrentUserLocation()
            if sessionManager.databaseManager.currentUser == nil {
                print("Error, no user loaded --- Running View")
                sessionManager.showSession()
            } else {
                print("inside the on appear else block running view")
                sessionManager.databaseManager.setRunStatus(status: .running)
            }
            
        })
    }
    
    // MARK: deleteThis
    // User's Coordinates:  CLLocationCoordinate2D(latitude: 35.7020691, longitude: 139.7753269)
    // locationManager - got locations: [<+35.70206910,+139.77532690> +/- 5.00m (speed -1.00 mps / course -1.00) @ 2/9/22, 1:27:34 AM Eastern Standard Time]

    func getCurrentUserLocation() {
        
        if sessionManager.databaseManager.currentUser == nil { 
            print("getCurrentUserLocation - userName: nil")
            
            // MARK: need to transition to error page not session page
            sessionManager.showSession()
        }
        
        locationService.storeUsername(id: sessionManager.databaseManager.currentUser?.username ?? "ERROR")
        
        locationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { coordinates in
                print("getCurrentUserLocation - user's Coordinates: ", coordinates)
                self.mapState.center = coordinates
                print("After the map!")
            }
            .store(in: &tokens)
        print("After the .store")
        
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView()
    }
}
