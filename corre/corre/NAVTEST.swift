//
//  NAVTEST.swift
//  corre
//
//  Created by Mariana Botero on 4/8/22.
//

import SwiftUI

struct NAVTEST: View {

    @State private var selectedTab = 0
    @State private var oldSelectedTab = 0
    
    //    let largeFont = UIFont.systemFont(ofSize: 60)

    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "primaryColor")

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "Varela Round Regular", size: 12)! ], for: .normal)
    }


    var body: some View {

        let home = Image("home.nofill")
                    .font(.system(size: 60))

        let homePressed = Image("home.fill")
                    .font(.system(size: 60))

        let run = Image("run.nofill")
                    .font(.system(size: 60))

        let runPressed = Image("run.fill")
                    .font(.system(size: 60))

        let friends = Image("friends.nofill")
                    .font(.system(size: 60))

        let friendsPressed = Image("friends.fill")
                    .font(.system(size: 60))

        let stats = Image("stats.nofill")
                    .font(.system(size: 60))

        let statsPressed = Image("stats.fill")
                    .font(.system(size: 60))



        TabView(selection: $selectedTab) {


            Text("no")
                .onTapGesture {
                    self.selectedTab = 0
                }
                .foregroundColor(.red)
                .tabItem {
                    selectedTab == 0 ? homePressed : home
                    Text("Home")
                        .font(.custom("Proxima Nova Rg Regular", size: 40))
                }.tag(0)
                .accentColor(Color.red)

            Text("HI")
                .onTapGesture {
                    self.selectedTab = 1
                }
                .tabItem {
                    selectedTab == 1 ? runPressed : run
                    Text("Run")
                        .font(.custom("Proxima Nova Rg Regular", size: 10))
                }.tag(1)

            Text("HI")
                .onTapGesture {
                    self.selectedTab = 2
                }
                .tabItem {
                    selectedTab == 2 ? friendsPressed : friends
                    Text("Friends")
                        .font(.custom("Proxima Nova Rg Regular", size: 10))
                }.tag(2)

            Text("HI")
                .onTapGesture {
                    self.selectedTab = 3
                }
                .tabItem {
                    selectedTab == 3 ? statsPressed : stats
                    Text("Profile")
                        .font(.custom("Proxima Nova Rg Regular", size: 10))
                }.tag(3)

        }.accentColor(Color("primaryColor"))

    }
}

struct NAVTEST_Previews: PreviewProvider {
    static var previews: some View {
        NAVTEST()
    }
}
