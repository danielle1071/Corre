//
//  EmergContactView.swift
//  corre
//  Skeleton
//  Created by Mariana Botero on 2/7/22.
//
//  SwiftUIView.swift
//  Profile-page
//
//  Created by Danielle Nau on 2/8/22.
//
//  Adapted by Lucas Morehouse on 2/10/22.
//

import SwiftUI

struct EmergContactView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }

    var body: some View {
        VStack{
            Button (action: {sessionManager.showSession()}){
            HStack{
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("primaryColor"))
                Text("Emergency Contacts")
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor"))
                Spacer()
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }




            Image("CreamLogo")
            .resizable()
            .frame(width: 125.0, height: 125.0)
            .scaledToFit()

            Button (action: {}){
                HStack{
                    Text("Jane Doe")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color("primaryColor"))
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)


            }


            Divider()
            .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)


            Spacer()

        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            if sessionManager.databaseManager.emergencyContacts.isEmpty {
                if sessionManager.databaseManager.currentUser.isEmpty {
                    print("Error, current user empty")
                    sessionManager.showSession()
                } else {
                    sessionManager.databaseManager.getEmergencyContacts()
                    print("This is the emergency contacs: \(sessionManager.databaseManager.emergencyContacts)")
                }
            }
        })

    }

}

struct EmergContactView_Previews: PreviewProvider {
    static var previews: some View {
        EmergContactView()
    }
}
