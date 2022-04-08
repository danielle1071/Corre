//
//  WatchLocationManager.swift
//  correWatch WatchKit Extension
//
//  Created by Lucas Morehouse on 4/8/22.
//

import Foundation
import CoreLocation
import Combine

final class WatchLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 28.6024, longitude: 81.2001)
    
    private var locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Returning early")
            return }
        coordinate = location.coordinate
        print ("Here are the cords: \(coordinate)")
    }
    
}
