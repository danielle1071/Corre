//
//  SignUpView.swift
//  corre
//
//  Created by Lucas Morehouse on 11/15/21.
//
//  Edited by Lauren Wright on 1/26/2022
//  Added UI
//
//  This file is based on the youtube tutorial: https://www.youtube.com/watch?v=wSHnmtnzbfs
//

import Foundation
import SwiftUI



struct SignUpView: View {
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    
    @EnvironmentObject var sessionManager: SessionManger
    
    @State private var birthDate = Date()
    let dateFormatter = DateFormatter()
    
        
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
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 76.0, height: 76.0)
                .scaledToFit()

            
            Text("Sign Up")
                .font(.system(size: 20.0))
                .foregroundColor(CustomColor.primarycolor)
            Group {
                
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
            
                TextField("Email", text: $email)
                TextField("Phone Number (+1##########)", text: $phone)
                TextField("First Name", text: $givenName)
                TextField("Last Name", text: $familyName)
                //TextField("Birthday (YYYY-MM-DD)", text: $dateOfBirth)
                HStack(alignment: .bottom){
                DatePicker(
                        "Birthday",
                        selection: $birthDate,
                        displayedComponents: [.date]
                    )
                    .colorInvert()
                    .colorMultiply(Color.blue)
                    .font(.system(size: 15.0))
                    
                Spacer(minLength: 165)
                        
                }
                
                Picker(selection: $gender, label: Text("Gender")) {
                        Text("Gender").tag(1)
                        Text("Male").tag(2)
                        Text("Female").tag(3)
                        Text("Other").tag(4)
                    }
                .frame(width: 350, height: 60, alignment: .leading)
            
            }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .padding([.horizontal], 20)
                .cornerRadius(16)
                .shadow(radius: 2.0)
            
            Group {
                TextField("City", text: $locality)
                TextField("State", text: $region)
                TextField("Country", text: $country)
                TextField("Zip Code (#####)", text: $postal_code)
            }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .padding([.horizontal], 20)
                .cornerRadius(16)
                .shadow(radius: 2.0)
            
            Spacer()
                .frame(height: 30)
            
            Button("Print BirthDate", action: {
                dateFormatter.dateFormat = "YYYY-MM-DD"
                dateOfBirth = dateFormatter.string(from: birthDate)
                print(dateOfBirth)
            })
            Button("Create Account", action: {
                dateFormatter.dateFormat = "YYYY-MM-DD"
                dateOfBirth = dateFormatter.string(from: birthDate)
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
                .padding()
                .foregroundColor(.white)
                .padding(.horizontal, 50)
                .background(CustomColor.primarycolor)
                .cornerRadius(20)
                
            
            VStack{
            
            
            Button("Already have an account? Sign in", action: {
                    sessionManager.showLogin()
                    })
                    .font(.system(size: 15.0))

            }
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
