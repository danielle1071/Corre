//
//  LocationManager.swift
//  corre
//
//  Created by Jon Abrigo on 2/7/22.
//

import Foundation
import Amplify
import AmplifyMapLibreUI
import AWSMobileClientXCF
import Combine
import CoreLocation
import SwiftUI

final class LocationManager: NSObject,
                             ObservableObject,
                             CLLocationManagerDelegate {
    
    @Published var sessionManager = SessionManger()
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    var locationManager: CLLocationManager = .init()
    
    override init() {
        super.init()
        requestLocation()
    }
    
    // MARK: startRun
    func startRun() {
        DispatchQueue.main.async {
            self.sessionManager.authState = .startRun
        }
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
            locationManager.startUpdatingLocation()
        default:
            print("locationManangerDidChangeAuthorization: Failed to authorize")
        }
    }
    
    
    
    // MARK: locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        
        // tracking implementations:
        print("locationManager - got locations: \(locations) ")
        
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


