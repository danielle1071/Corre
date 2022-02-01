//
//  StartRunView.swift
//  corre
//
//  Created by Jon Abrigo on 1/30/22.
//

import AmplifyMapLibreUI
import Foundation
import SwiftUI
import Amplify

struct StartRunView: View {
    @EnvironmentObject var sessionManager: SessionManger
    
    @State var mapState = AMLMapViewState()
    
    let user: AuthUser
    
    var body: some View {
        VStack {
            AMLMapView(mapState: mapState)
                .edgesIgnoringSafeArea(.all)
            
            
        }
        
    }
}

