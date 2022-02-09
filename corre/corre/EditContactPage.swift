//
//  EditContact.swift
//  Profile-page
//
//  Created by Danielle Nau on 2/8/22.
//

import SwiftUI

struct EditContactPage: View {
    @State var ecFirst: String = ""
    @State var ecLast: String = ""
    @State var ecEmail: String = ""
    @State var ecPhone: String = ""
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
        
    var body: some View {
        VStack{
            
            Button (action: {}){
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
            
            VStack{
                Group {
                TextField("First Name", text: $ecFirst)
                TextField("Last Name", text: $ecLast)
                TextField("E-mail", text: $ecEmail)
                TextField("Phone Number", text: $ecPhone)
                    }
                    .padding(15)
                    .padding([.horizontal], 25)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .padding([.horizontal], 25))
            }
            Button (action: {}){
            Text("Save Changes")
                .foregroundColor(Color("primaryColor"))
            }
            Spacer()

    }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
       
}
}
struct EditContact_Previews: PreviewProvider {
    static var previews: some View {
        EditContactPage()
    }
}
