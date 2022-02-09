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
    
    func startRun() {
        DispatchQueue.main.async {
            self.sessionManager.authState = .startRun
        }
    }
    
    func requestLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        coordinatesPublisher.send(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


