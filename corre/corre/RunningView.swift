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
    // map
    @EnvironmentObject var sessionManager: SessionManger
    @StateObject var locationService = LocationManager()
    @State var tokens: Set<AnyCancellable> = .init()
    @State var mapState = AMLMapViewState(zoomLevel: 17)
    @State var phoneNumber: String
    
    func startTimer() {
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
          if self.seconds == 59 {
            self.seconds = 0
            if self.minutes == 59 {
              self.minutes = 0
              self.hours = self.hours + 1
            } else {
              self.minutes = self.minutes + 1
            }
          } else {
            self.seconds = self.seconds + 1
          }
        }
    }
    
    func stopTimer() {
       timerIsPaused = true
       timer?.invalidate()
       timer = nil
     }
     
     func restartTimer() {
       hours = 0
       minutes = 0
       seconds = 0
     }
    
    // timer
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    
    // sliding window
    @State private var showingPopover = false
    @State private var showingPopover_1 = false
    @State private var timeRemaining = 100
    let timer_1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    // run stats
    var DEBUG = true
    @State var userSpeed: Double = 0.00
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }
    
    @GestureState var highlight = false
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .onEnded { _ in
                sessionManager.databaseManager.setRunStatus(status: .notrunning)
                
                // informs all emergency contact
                self.endRunNotif()
                
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
                // Pop ups for check in and run stats
                //
                Button (action: {showingPopover = true}){
                    
                    HStack{
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color("primaryColor"))
                    }
                }
                .popover(isPresented: $showingPopover) {
                    ZStack{
                        CusColor.backcolor.edgesIgnoringSafeArea(.all)
                    VStack{
                    Text("Running Statistics")
                                .font(.headline)
                                .padding()
                    Text("Distance: 0")
                    Text("Current pace: 0")
                    Spacer()
                    }
                    
                        }
                }
                
                
                Button (action: {showingPopover_1 = true}){
                    
                    HStack{
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(Color.red)
                    }
                }
                .popover(isPresented: $showingPopover_1) {
                    
                    ZStack{
                        CusColor.backcolor.edgesIgnoringSafeArea(.all)
              
                    VStack{
                            Text("Check In")
                                .font(.headline)
                                .padding()
                    
                    Text("Are you ok?")
                        // just an example
                    Text("Reason: idle for too long")
                    Text("Time remaining to respond: \(timeRemaining) seconds")
                            .onReceive(timer_1) { time in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                        HStack{
                            Button(action:{
                                self.showingPopover_1 = false
                                
                                timer_1.upstream.connect().cancel()
                            
                            }, label: {
                                Text("Yes")
                                    .fontWeight(.bold)
                                    .frame(width: 150, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color.white)
                                    .background(CusColor.primarycolor)
                                    .clipShape(Capsule())
                            })
                            Button(action:{
                            }, label: {
                                Text("SOS")
                                    .fontWeight(.bold)
                                    .frame(width: 150, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color.white)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                            })
                        
                        
                        }
                    Spacer()
                        }
                }
                }
                //
                Spacer()
                HStack{
                    Text("Time Elapsed: \(hours):\(minutes):\(seconds)")
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
                // start timer when maps appear
                    .onAppear(perform: {self.startTimer()})
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
                    // stops timer
                    self.stopTimer()
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
            // resets timer to zero
            // since there is no start run button just change action to self.restartTimer() for testing purposes
            Button(action:{ self.restartTimer()
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
                if (DEBUG) { print("Error, no user loaded --- Running View") }
                sessionManager.showSession()
            } else {
                if (DEBUG) { print("inside the on appear else block running view") }
                
                // set user running status to running
                sessionManager.databaseManager.setRunStatus(status: .running)
                
                // notify user's emergency contacts regarding changed running status
                self.startRunNotif()
            }
        })
    }

    func getCurrentUserLocation() {
        
        var currSpeed = 0.00
        var currDistance = 0.00
        
        if sessionManager.databaseManager.currentUser == nil {
            print("ERROR: getCurrentUserLocation -> userName: nil")
            
            // MARK: need to transition to error page not session page
            sessionManager.showSession()
        }
        
        locationService.storeUsername(id: sessionManager.databaseManager.currentUser?.username ?? "ERROR")
        
        locationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { coordinates in
                print("RunningView -> getCurrentUserLocation -> user's Coordinates: ", coordinates)
                self.mapState.center = coordinates
                
                if (DEBUG) {
                    // print("RunningView -> getCurrentUserLocation -> locationService.userSpeed: \(locationService.userSpeed!)")
                    // print("RunningView -> getCurrentUserLocation -> totalSpeedSum: \(totalSpeed)")
                    // calculateDistance(hours: 0, minutes: 0, seconds: 1, speed: 2.75)
                }
                
                print("RunningView -> getCurrentUserLocation -> timer: \(hours)hr \(minutes)min \(seconds)sec")
                
                currSpeed = locationService.userSpeed!
                
                isCurrSpeedNormal(
                    hours: hours,
                    minutes: minutes,
                    seconds: seconds,
                    speed: currSpeed)
                
                
                
                
            }
            .store(in: &tokens)
        print("After the .store")
        
        
    }
    
    func isCurrSpeedNormal(hours: Int,
                       minutes: Int,
                       seconds: Int,
                       speed: Double) -> Bool {
        
        // check if the user is not idle
        if (speed > 0.00 && speed < 7.88) {
            userSpeed = speed
            return true
        }
        
        // user is moving too quickly!
        else if (speed >= 7.88) {
            
            // MARK: trigger sliding window here!
            togglePopover()
            
            // MARK: send RUNEVENT notification here
            
            // MARK: set email notification here!
            
            return false
        }
        
        // user has been idle for too long?
        else {
            // if the user was running prior to idle, reset totalSpeed to zero
            if (userSpeed > 0.00) { userSpeed = 0.00 }
            
            userSpeed += locationService.userSpeed!
            
            // if the user has accumulated a userSpeed of -20, this means that the user
            // has been idle for 10mins or (600sec divided by 30sec)
            if (DEBUG ? userSpeed == -2.00 : userSpeed == -20.00) {
                // revert it back to zero to check on user again after an additional
                // 10 mins of idle
                userSpeed = 0.00
                
                // MARK: trigger sliding window here!
                togglePopover()
                
                // MARK: send RUNEVENT notification here
                
                // MARK: set email notification here!
                
                
                return false
            }
            
            // if the user's idle is less than 10min
            return true
        }
    }
    
    func togglePopover() {
        if (DEBUG) { print("RunningView -> togglePopover triggered!") }
        
        if (showingPopover_1 == false) {
            showingPopover_1 = true
        }
        
        
        else {
            showingPopover_1 = false
        }
    }
    
    func calculateDistance(hours: Int,
                           minutes: Int,
                           seconds: Int,
                           speed: Double) -> Double {
        
        var h = Double(hours)
        var m = Double(minutes)
        var s = Double(seconds)
        var distance: Double
        
        if (DEBUG) { print("RunningView -> calculateDistance -> timerToDouble: \(h)hr \(m)min \(s)sec ") }
        
        // if either hr or min is not 0, then convert them to seconds
        if (h != 0.00) { m += (h * 60.00) }
        if (m != 0.00) { s += (m * 60.00) }
        
        if (DEBUG) { print("RunningView -> calculateDistance -> timeCombined: \(s)sec ") }
        
        distance = speed * s
        
        if (DEBUG) { print("RunningView -> calculateDistance -> distance: \(distance)m ") }
        
        return distance
    }
    
    func startRunNotif() {
        
        sessionManager.databaseManager.getEmergencyContacts()
        let contacts = sessionManager.databaseManager.emergencyContacts
        
        contacts.forEach { contact in contacts
            if (DEBUG) {
                print("RunningView -> startRunNotif -> Emergency Contact: \(contact.id) and \(String(describing: contact.emergencyContactAppUsername))")
            }
            
            // In the event that the emergency has an account through corre,
            // send them a start run notification in the app
            if (contact.emergencyContactAppUsername != nil) {
                sessionManager.databaseManager.startRunNotification(username: contact.emergencyContactAppUsername!)
            }
            
            // MARK: add email logic here!
            
        }
    }
    
    func endRunNotif() {
    
        sessionManager.databaseManager.getEmergencyContacts()
        let contacts = sessionManager.databaseManager.emergencyContacts
        
        contacts.forEach { contact in contacts
            if (DEBUG) {
                print("RunningView -> endRunNotif -> Emergency Contact: \(contact.id) and \(String(describing: contact.emergencyContactAppUsername))")
            }
            
            // In the event that the emergency has an account through corre,
            // send them a start run notification in the app
            if (contact.emergencyContactAppUsername != nil) {
                sessionManager.databaseManager.endRunNotification(username: contact.emergencyContactAppUsername!)
            }
            
            // MARK: add email logic here!
            
        }
    }
    
    
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView(phoneNumber: "+10000000000")
    }
}
