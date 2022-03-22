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
    @State var mapState = AMLMapViewState(zoomLevel: 17)
    @State var phoneNumber: String
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }
    
    // MARK: Phone Number
    // example phone number. Refer to SOS button
    //    var phoneNumber = "718-555-5555"
    
    @GestureState var highlight = false
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .onEnded { _ in
                sessionManager.databaseManager.setRunStatus(status: .notrunning)
                sessionManager.showNavBar()

                // stops tracker resources
                locationService.stopTracking()
            }
            .updating($highlight) {
                currentstate, gestureState, transaction in
                transaction.animation = Animation.easeInOut(duration: 3.0)
                gestureState = currentstate
            }
    }

    var body: some View {
        // MARK: remove after testing
        // Text("SOS Phone Number: \(phoneNumber)")
        
        VStack {
            // MARK: change this to stop run!
            HStack{
                Button(action: {
                sessionManager.databaseManager.setRunStatus(status: .notrunning)
                sessionManager.showPreRunning()
                
                // stops tracker resources
                locationService.stopTracking()
            }, label: {
                Image(systemName: "arrow.left")
                    .renderingMode(.original)
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color("primaryColor"))
                Text("Back")
                    .font(.custom("Varela Round Regular", size: 18))
                    .foregroundColor(Color("primaryColor"))
                })
                
                Spacer()
                HStack{
                    Text("Time Elapsed: 00:00:00")
                }
                .padding(/*@START_MENU_TOKEN@*/.trailing, 9.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color("primaryColor"))
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            ZStack {
                AMLMapView(mapState: mapState)
                    .showUserLocation(true)
                    .frame(width: /*@START_MENU_TOKEN@*/350.0/*@END_MENU_TOKEN@*/, height: 550)
                    .cornerRadius(20)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(radius: 2)
            }
            Spacer()
            
        
            HStack(spacing: 30)  {
                // call emergency contact with example phone number
                Button(action:{
                    let phone = "tel://"
                                    let phoneNumberformatted = phone + phoneNumber
                                    guard let url = URL(string: phoneNumberformatted) else { return }
                                    UIApplication.shared.open(url)
                }, label: {
                    Text("SOS")
                        .fontWeight(.bold)
                        .frame(width: 160.0, height: 60.0)
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0,
                                                    style: .circular))
                })
                
                Button(action:{
                }, label: {
                    Text("Pause Run")
                        .fontWeight(.bold)
                        .frame(width: 160.0, height: 60.0)
                        .foregroundColor(Color.white)
                        .background(CusColor.primarycolor)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0,
                                                    style: .circular))
                })
            }
            .padding(5.0)
            Spacer()
            
            Button(action:{
            }, label: {
                Text("Stop Run")
                    .fontWeight(.bold)
                    .frame(width: 350.0, height: 60.0)
                    .foregroundColor(Color.white)
                    .background(self.highlight ? Color.red : CusColor.primarycolor)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0,
                                                style: .circular))
                    .gesture(longPress)
            })
            
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
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
                print("getCurrentUserLocation - after the map!")
            }
            .store(in: &tokens)
        print("After the .store")
        
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView(phoneNumber: "+10000000000")
    }
}
