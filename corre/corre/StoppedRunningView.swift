//
//  StoppedRunningView.swift
//  corre
//
//  Created by Mariana Botero on 3/27/22.
//

import SwiftUI
import Foundation

struct StoppedRunningView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let gWidth = geometry.size.width
            let gHeight = geometry.size.height
            
            HStack (spacing: gWidth * 0.08) {
                VStack (alignment: .leading, spacing: 0){
                    Button(action: {
                        sessionManager.showSession()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .renderingMode(.original)
                            .edgesIgnoringSafeArea(.all)
                            .foregroundColor(Color("primaryColor"))
                        Text("Back")
                            .foregroundColor(Color("primaryColor"))
                            .font(.custom("Varela Round Regular", size: 20))
                    })
                }
                Text("Stopped Running")
                    .foregroundColor(Color("primaryColor"))
                    .font(.custom("Varela Round Regular", size: 20))
                    
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(
                Image("StoppedRunning")
            )
        

        }
    }
}

struct StoppedRunningView_Previews: PreviewProvider {
    
    static var previews: some View {
        StoppedRunningView()
    }
}
