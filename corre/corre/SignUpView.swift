//
//  SignUpView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

import Foundation
import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManger
        
    @State var givenName = ""
    @State var familyName = ""
    @State var email = ""
    @State var dateOfBirth = ""
    @State var phone = ""
    @State var password = ""
    @State var username = ""
    @State var gender = ""
    @State var locality = ""
    @State var region = ""
    @State var postal_code = ""
    @State var country = ""
   
    
    var body: some View {
        VStack{
            Spacer()
            
            Group {
                
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
            
                TextField("Email", text: $email)
                TextField("Phone Number (+1##########)", text: $phone)
                TextField("First Name", text: $givenName)
                TextField("Last Name", text: $familyName)
                TextField("Birthday (YYYY-MM-DD)", text: $dateOfBirth)
                TextField("Gender", text: $gender)
            }
            Group {
                TextField("City", text: $locality)
                TextField("State", text: $region)
                TextField("Country", text: $country)
                TextField("Zip Code (#####)", text: $postal_code)
            }
            
            Button("Sign Up", action: {
                sessionManager.signUp(
                    username: username,
                    email: email,
                    phone: phone,
                    password: password,
                    givenName: givenName,
                    familyName: familyName,
                    dateOfBirth: dateOfBirth,
                    locality: locality,
                    region: region,
                    postal_code: postal_code,
                    country: country,
                    gender: gender
                )
            })
            
            Spacer()
            Button("already a user? sign-in", action: {
                    sessionManager.showLogin()
                    })
        }
        .padding()
    }
    /*
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
     */
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
