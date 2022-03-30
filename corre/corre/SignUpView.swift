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
//  Edited by Lucas Morehouse on 3/21/22
//  


import Foundation
import SwiftUI



struct SignUpView: View {
    
    init(){
            UITableView.appearance().backgroundColor = .clear
            UITableView.appearance().contentInset.top = -35
        }
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    
    @EnvironmentObject var sessionManager: SessionManger
    @State var userExist = false
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
    @State var reTypePassword = ""
   
    
    var body: some View {
        
        VStack{
            
            HStack{
            Image("CreamLogo")
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .scaledToFit()
            Text("Sign Up")
                    .font(.custom("Varela Round Regular", size: 30))
                .foregroundColor(CustomColor.primarycolor)
            }
            Group {
                TextField("First Name", text: $givenName)
                    .frame(width: 320, height: 50)
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .padding([.horizontal], 10)
                    .background(.white)
                    .cornerRadius(15)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("textLight"), lineWidth: 0.8)
                    )
                TextField("Last Name", text: $familyName)
                    .frame(width: 320, height: 50)
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .padding([.horizontal], 10)
                    .background(.white)
                    .cornerRadius(15)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("textLight"), lineWidth: 0.8)
                    )
        
                TextField("Username", text: $username)
                    .frame(width: 320, height: 50)
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .padding([.horizontal], 10)
                    .background(.white)
                    .cornerRadius(15)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("textLight"), lineWidth: 0.8)
                    )
              
               
                Group {
                    SecureField("Password", text: $password)
                        .frame(width: 320, height: 50)
                        .font(.custom("Proxima Nova Rg Regular", size: 20))
                        .padding([.horizontal], 10)
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("textLight"), lineWidth: 0.8)
                        )
                    if password != "" && reTypePassword != "" {
                        if password != reTypePassword {
                            Text("Password must have 1 uppercase, 1 lowercase, 1 number, 1 special character, and a length of 8")
                                .font(.custom("Proxima Nova Rg Regular", size: 10))
                                .foregroundColor(Color.red)
                                .padding([.horizontal], 20)
                                .multilineTextAlignment(.center)
                        }
                    }
                    SecureField("Re-type Password", text: $reTypePassword)
                        .frame(width: 320, height: 50)
                        .font(.custom("Proxima Nova Rg Regular", size: 20))
                        .padding([.horizontal], 10)
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("textLight"), lineWidth: 0.8)
                        )
                    if password != "" && reTypePassword != "" {
                        if password == reTypePassword {
                            Text("Password match")
                                .font(.custom("Proxima Nova Rg Regular", size: 10))
                                .foregroundColor(Color.green)
                        } else {
                            Text("Passwords do not match")
                                .font(.custom("Proxima Nova Rg Regular", size: 10))
                                .foregroundColor(Color.red)
                        }
                        
                    }
                    
                }
                TextField("Email", text: $email)
                    .frame(width: 320, height: 50)
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    .padding([.horizontal], 10)
                    .background(.white)
                    .cornerRadius(15)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("textLight"), lineWidth: 0.8)
                    )
                    
                if userExist {
                    Text("user exists with that email")
                        .font(.system(size: 10.0))
                        .foregroundColor(Color.red)
                }
                Group {
                    TextField("Phone Number (+1##########)", text: $phone)
                        .frame(width: 320, height: 50)
                        .font(.custom("Proxima Nova Rg Regular", size: 20))
                        .padding([.horizontal], 10)
                        .background(.white)
                        .cornerRadius(15)
                        .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("textLight"), lineWidth: 0.8)
                        )
                
                HStack(alignment: .bottom){
                DatePicker(
                        "Birthday",
                        selection: $birthDate,
                        displayedComponents: [.date]
                    )
                    .padding([.horizontal], 31)
                    .colorInvert()
                    .colorMultiply(Color.blue)
                    .font(.custom("Proxima Nova Rg Regular", size: 20))
                    
                Spacer(minLength: 0)
                        
                }
                
                Picker(selection: $gender, label: Text("Gender")) {
                                      Text("Gender").tag(1)
                                      Text("Male").tag(2)
                                      Text("Female").tag(3)
                                      Text("Other").tag(4)
                                  }
                .frame(width: 330, height: 30, alignment: .leading)
            
                }
                
            }
                
            
            Spacer()
                .frame(height: 20)
            
            Button("Create Account", action: {
                if email != "" {
                
                    userExist = sessionManager.databaseManager.checkUserExists(email: email)
                    print("Here is the result \(userExist)")
                    if !userExist {
                        print("User doesn't exist!")
                    }
                    
                    if !userExist {
                        if (password == reTypePassword) {
                            dateFormatter.dateFormat = "YYYY-MM-dd"
                            dateOfBirth = dateFormatter.string(from: birthDate)
                            sessionManager.signUp(
                                username: username,
                                email: email.lowercased(),
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
                        }
                    }
                }
            })
                .padding()
                .foregroundColor(.white)
                .padding(.horizontal, 90)
                .background(CustomColor.primarycolor)
                .cornerRadius(20)
                .font(.custom("Proxima Nova Rg Regular", size: 18))
                
            Divider()
                .padding([.top], 30)
            HStack {
                
                Button("Already have an account? Sign in", action: {
                        sessionManager.showLogin()
                        })
                .font(.custom("Proxima Nova Rg Regular", size: 18))
                
                
            }.padding([.top], 10)
            
            
            
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
    
    
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
