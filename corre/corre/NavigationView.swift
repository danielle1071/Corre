//
//  NavigationView.swift
//  corre
//
//  Created by Mariana Botero on 2/15/22.
//

import Foundation
import SwiftUI
import Amplify


struct NavigationView: View {

    @EnvironmentObject var sessionManager: SessionManger

    
    var body: some View {
        
        TabView {
                SessionView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("sesh")
                }
                RunningView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("run")
                }
                FriendView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("friend")
                }

                ProfileView()
                    .tabItem {
                        Image(systemName: "mappin.circle.fill")
                        Text("prof")
                }
                
            
            
            }

    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
