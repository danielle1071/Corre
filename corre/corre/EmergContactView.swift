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
    @State var addedContact = false
    @State var ecFirst = ""
    @State var ecLast = ""
    @State var ecEmail = ""
    @State var ecPhone = ""
    
    var body: some View {
    
        
        Text("Hello! This is the Emergency Contact view🚨🚨🚨").font(.largeTitle)

        
    }
}

struct EmergContactView_Previews: PreviewProvider {
    static var previews: some View {
        EmergContactView()
    }
}
