//
//  ContentView.swift
//  Corre-RunningMap
//
//  Created by Danielle Nau on 2/1/22.
//
import SwiftUI

struct RunningMap: View {
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    var body: some View {
        
            VStack{
                HStack{
                    Image(systemName: "arrow.left")
                    .renderingMode(.original)
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color("primaryColor"))
                    Text("Active Run")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                    HStack{
                        Text("Time Elapsed: 00:00:00")
                    }
                    .padding(/*@START_MENU_TOKEN@*/.trailing, 9.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color("primaryColor"))
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
               
                VStack{
                ZStack{
                    Image("map")
                    .resizable()
                .frame(width: /*@START_MENU_TOKEN@*/350.0/*@END_MENU_TOKEN@*/, height: 550)
                    .cornerRadius(20)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(radius: 2)
                    
                }
                }
                  Spacer()
                  
                VStack(alignment: .center){
                    Button(action:{}, label: {
                        Text("SOS")
                            .fontWeight(.bold)
                            .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.white)
                            .background(Color.red)
                            .clipShape(Capsule())
                    })
                    
                    Button(action:{
                    }, label: {
                        Text("Emergency Contacts")
                            .fontWeight(.bold)
                            .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.white)
                            .background(CusColor.primarycolor)
                            .clipShape(Capsule())
                    })
                    
                    Button(action:{
                    }, label: {
                        Text("Pause Run")
                            .fontWeight(.bold)
                            .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.white)
                            .background(CusColor.primarycolor)
                            .clipShape(Capsule())
                    })
                                    }
                .padding(5.0)
            }
            .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
       
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RunningMap()
    }
}


