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


struct RunningView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    var body: some View {
        
        Spacer()
     
        Text("Hello! This is the running view 🏃‍♀️🏃‍♀️🏃‍♀️🏃‍♀️").font(.largeTitle)
        
        Spacer()
        
        Button("Sign Out", action: {
            sessionManager.signOut()
        })
        
        
        
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView()
    }
}
