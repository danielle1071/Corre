//
//  LocationManager.swift
//  corre
//
//  Created by Jon Abrigo on 2/7/22.
//

import Foundation
import Amplify
import Combine
import CoreLocation
import SwiftUI

// Sends device location data to Amazon Location Service
import AWSMobileClientXCF
import AWSLocationXCF

final class LocationManager: NSObject,
                             ObservableObject,
                             CLLocationManagerDelegate,
                             AWSLocationTrackerDelegate {
    
    // MARK: deleteThis
    // @Published var sessionManager = SessionManger()
    // var sessionMananger: SessionManger
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    var locationManager: CLLocationManager = .init()
    var sessionManager: SessionManger?
    // tracking implementation:
    let locationTracker = AWSLocationTracker(trackerName: "correTracker",
                                             region: AWSRegionType.USEast1,
                                             credentialsProvider: AWSMobileClient.default())
    var device: Device?
    // @EnvironmentObject var sessionManager: SessionManger
    
    private var userName: String?
    
    override init() {
        super.init()
        requestLocation()
    }
    
    func setSessionManager(sessionManager: SessionManger) {
        self.sessionManager = sessionManager
        print("success! Set the session manager correctly!")
        print("Current user in the location manager: \(sessionManager.databaseManager.currentUser)")


        if self.sessionManager == nil {
            print("FATAL ERROR IN LOCATION MANAGER --- SESSION MANAGER = NIL")
            return
        }

        if self.sessionManager!.databaseManager.currentUser == nil {
            print("ERROR: NO CURRENT USER LOADED --- LOCATION MANAGER")
            return
        }

        let userDeviceID = self.sessionManager!.databaseManager.currentUser?.id
        self.device = self.sessionManager?.databaseManager.findDeviceRecord(userDeviceID: userDeviceID!)
        print("This is the device in the location manager: \(self.device)")

    }
    
    // MARK: deleteThis
    //    func startRun() {
    //        DispatchQueue.main.async {
    //            self.sessionMananger.authState = .startRun
    //        }
    //    }
    //    func test(id: String) {
    //        userName = id
    //        print("You got here ### :  \(id)", " and! ", userName)
    //    }
    
    // MARK: storeUsername
    func storeUsername(id: String) {
        userName = id
    }
    
    // MARK: requestLocation
    func requestLocation() {
        locationManager.delegate = self
        
        // tracking implementation:
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    // MARK: locationManagerDidChangeAuthorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            
            print("locationManangerDidChangeAuthorization: Received authorization of user location, requesting for location")
            
            let result = locationTracker.startTracking(
                delegate: self,
                options: TrackerOptions(
                    // Sets the custom ID chosen to identify this device
                    // on the chosen tracker resource.
                    customDeviceId: userName,
                    // customDeviceId: Amplify.Auth.getCurrentUser()?.userId,
                    
                    // Sets the frequency in seconds to get the
                    // current device location.
                    retrieveLocationFrequency: TimeInterval(10),
                    
                    // Sets the frequency in seconds to publish a batch
                    // of locations to Amazon Location Service.
                    emitLocationFrequency: TimeInterval(20)),
                
                // listener: onTrackingEvent(event: result))
                listener: onTrackingEvent)
            
            switch result {
                case .success:
                    print("locationTracker: Tracking started successfully")
                
                case .failure(let trackingError):
                    switch trackingError.errorType {
                    case .invalidTrackerName, .trackerAlreadyStarted, .unauthorized:
                        print("locationTracker: onFailedToStart \(trackingError)")
                        
                    case .serviceError(let serviceError):
                        print("locationTracker - onFailedToStart serviceError: \(serviceError)")
                    }
            }
            
            // IMPORTANT: This will continuously retrieve a stream of location updates,
            //            rather than tracking the location at an interval.
            // locationManager.startUpdatingLocation()
        default:
            print("locationManangerDidChangeAuthorization - default: Failed to authorize")
        }
    }
    
    // MARK: onTrackingEvent
    func onTrackingEvent(event: TrackingListener) {
        switch event {
        case .onDataPublished(let trackingPublishedEvent):
            print("onTrackingEvent - onDataPublished: \(trackingPublishedEvent)")
            
        case .onDataPublicationError(let error):
            switch error.errorType {
            case .invalidTrackerName, .trackerAlreadyStarted, .unauthorized:
                print("onTrackingEvent - onDataPublicationError \(error)")
                
            case .serviceError(let serviceError):
                print("onTrackingEvent - onDataPublicationError serviceError: \(serviceError)")
            }
        case .onStop:
            print("onTrackingEvent - tracker stopped")
        }
    }
    
    // MARK: stopTracking
    func stopTracking() {
        locationTracker.stopTracking()
    }
    
    // MARK: isTracking
    func isTracking() -> Bool {
        locationTracker.isTracking()
    }
    
    // MARK: locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Checking this device: \(self.device)")
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        
        // tracking implementations:
        print("locationManager - got locations: \(locations) ")
        print("This is the location xCord: \(location.coordinate.latitude)")
        print("This is the location yCord: \(location.coordinate.longitude)")
        sessionManager!.databaseManager.updateDeviceLocation(
                                                            device: device!,
                                                            xCord: location.coordinate.latitude,
                                                            yCord: location.coordinate.longitude
                                                            )
        // When Corre retrieves location updates, pass the data for location tracking to
        // update the tracker
        locationTracker.interceptLocationsRetrieved(locations)
        
        coordinatesPublisher.send(location.coordinate)
    }
    
    // MARK: locationManager - Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // tracking implementations:
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("clError: location unknown")
                
            case CLError.denied:
                print("clError: denied")
                
            default:
                print("clError: default - other Core Location error")
            }
        } else {
            print ("else-clError: (other) ", error.localizedDescription)
        }
    }
}

