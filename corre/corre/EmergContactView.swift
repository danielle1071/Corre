//
//  EmergContactView.swift
//  corre
//
//  Created by Mariana Botero on 2/7/22.
//

import Foundation
import SwiftUI
import Amplify


struct EmergContactView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    var body: some View {
        
        Spacer()
        
        Text("Hello! This is the Emergency Contact view🚨🚨🚨").font(.largeTitle)
        Spacer()
        
        Button("Sign Out", action: {
            sessionManager.signOut()
        })
        
    }
}

struct EmergContactView_Previews: PreviewProvider {
    static var previews: some View {
        EmergContactView()
    }
}
