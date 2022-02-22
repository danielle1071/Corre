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

import SwiftUI
import Foundation
import Amplify
import Combine
import AmplifyMapLibreUI

struct EmergContactView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }

    var body: some View {
        
        // MARK: this needs to be a tab.. placeholder
        Button("Track Contacts View", action: {
            sessionManager.showTrackContacts()
        }).padding()
            .padding(.horizontal, 108)
            .foregroundColor(CustomColor.primarycolor)
            .background(CustomColor.backcolor)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                .stroke(CustomColor.primarycolor, lineWidth: 2))
        
        VStack{
 
            Button (action: {sessionManager.showSession()}){
            HStack{
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("primaryColor"))
                Text("Emergency Contacts")
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor"))
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }

            Image("CreamLogo")
            .resizable()
            .frame(width: 125.0, height: 125.0)
            .scaledToFit()

            Button (action: {}){
                HStack{
                    Text("Jane Doe")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color("primaryColor"))
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)


            }

            Divider()
            .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)

        }
        
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            if sessionManager.databaseManager.emergencyContacts.isEmpty {
                if sessionManager.databaseManager.currentUser == nil {
                    print("Error, current user empty")
                    sessionManager.showSession()
                } else {
                    sessionManager.databaseManager.getEmergencyContacts()
                    print("This is the emergency contacs: \(sessionManager.databaseManager.emergencyContacts)")
                }
            }
        })
    }
}

//<<<<<<< HEAD
//    @StateObject var locationService = LocationManager()
//    @State var tokens: Set<AnyCancellable> = .init()
//    @State var mapState = AMLMapViewState()
//
//    let user: AuthUser
//
//    var body: some View {
//
//        VStack {
//
//            // MARK: change this to stop run!
//            Button("Back", action: {
//                sessionManager.showSession()
//
//                // stops tracker resources
//                locationService.stopTracking()
//            })
//
//=======
//>>>>>>> 8d637eb231977b632cc5e55feb18cb9de61b328d
//            Spacer()
//
//            AMLMapView(mapState: mapState)
//                .showUserLocation(true)
//                .edgesIgnoringSafeArea(.all)
//
//
//            Spacer()
//            Text("Tracking view")
//            Spacer()
//
//            Button("Sign Out", action: {
//                sessionManager.signOut()
//            })
//        }
//<<<<<<< HEAD
//        .onAppear(perform: getRunnerLocation)
//    }
//
//
//    func getRunnerLocation() {
//
//        locationService.storeUsername(id: "Database")
//
//        locationService.coordinatesPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { coordinates in
//                print("getCurrentUserLocation - user's Coordinates: ", coordinates)
//                self.mapState.center = coordinates
//            }
//            .store(in: &tokens)
//
//=======
//>>>>>>> 8d637eb231977b632cc5e55feb18cb9de61b328d
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
//struct EmergContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmergContactView(user: AuthUser.self as! AuthUser)
//    }
//}
