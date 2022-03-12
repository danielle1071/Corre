//
//  UINotificationView.swift
//  corre
//
//  Created by Danielle Nau on 3/2/22.
//

import SwiftUI

struct UINotificationView: View {
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
                Text("Notifications")
                    .padding()
                    .foregroundColor(Color("primaryColor"))
                Spacer()
                Image(systemName: "bell.circle.fill")
                    .resizable()
                    .foregroundColor(Color("primaryColor"))
                    .frame(width: 28.0, height: 28.0)
                    .scaledToFit()
                    .padding(.trailing, 5.0)
            
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            ScrollView{
            
                
                HStack{
                Text("Username sent a friend request")
                    //.fontWeight(.medium)
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor"))
                
               Spacer()
                
                HStack{
                    Button (action: {}){
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .foregroundColor(Color("red"))
                        
                        .frame(width: 25.0, height: 25.0)
                        .scaledToFit()
                        .padding(/*@START_MENU_TOKEN@*/.trailing, 10.0/*@END_MENU_TOKEN@*/)
                    }
                   
                    Button (action: {}){
                    Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(Color("primaryColor"))
                            .frame(width: 25.0, height: 25.0)
                            .scaledToFit()
                    }
                    
                   
                }
                .padding(.trailing, 20.0)
           
                }
                // end here
                HStack{
                    Text("Username sent a emergency contact request")
                        //.fontWeight(.medium)
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color("primaryColor"))
                    
                   Spacer()
                    
                    HStack{
                        Button (action: {}){
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .foregroundColor(Color("red"))
                            
                            .frame(width: 25.0, height: 25.0)
                            .scaledToFit()
                            .padding(/*@START_MENU_TOKEN@*/.trailing, 10.0/*@END_MENU_TOKEN@*/)
                        }
                        Button (action: {}){
                        Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .foregroundColor(Color("primaryColor"))
                                .frame(width: 25.0, height: 25.0)
                                .scaledToFit()
                        }
                        
                       
                    }
                    .padding(.trailing, 20.0)
                }
                HStack{
                    Text("Unread message from username")
                        //.fontWeight(.medium)
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color("primaryColor"))
                    
                   Spacer()
                    
                    HStack{
                        Button (action: {}){
                        Image(systemName: "bubble.right.circle.fill")
                                .resizable()
                                .foregroundColor(Color("primaryColor"))
                                .frame(width: 27.0, height: 27.0)
                                .scaledToFit()
                        }
                        
                       
                    }
                    .padding(.trailing, 20.0)
                }
            
            
            
            }
            
            
            
            
            
            
            
           
      
            Divider()
            
            Spacer()

    }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
}

struct UINotificationView_Previews: PreviewProvider {
    static var previews: some View {
        UINotificationView()
    }
}
