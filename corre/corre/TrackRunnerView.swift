//
//  TrackRunnerView.swift
//  corre
//
//  Created by Lucas Morehouse on 2/13/22.
//

import SwiftUI
import Foundation
import Amplify
import Combine
import AmplifyMapLibreUI

struct TrackRunnerView: View {
    
    
    @EnvironmentObject var sessionManager: SessionManger
    
    //MARK: have the map view live while the user that is beign tracked has a running status of !NOTRUNNING
    
    var body: some View {
        
        VStack {
            Button("Back", action: sessionManager.showSession)
            
        }
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TrackRunnerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackRunnerView()
    }
}
