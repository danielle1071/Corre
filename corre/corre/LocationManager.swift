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

final class LocationManager: ObservableObject {
    @Published var sessionManager = SessionManger()
    
    func startRun() {
        DispatchQueue.main.async {
            self.sessionManager.authState = .startRun
        }
    }
}


