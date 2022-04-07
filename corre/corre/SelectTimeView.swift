//
//  SelectTimeView.swift
//  corre
//
//  Created by Danielle Nau on 3/22/22.
//

import SwiftUI

struct SelectTimeView: View {
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    var hours = Array(0...23)
       var min = Array(0...59)
       
    @State var selectedHours:Int = 0
    @State var selectedMins: Int = 0
   
    
    var body: some View {
       
        ZStack{
           CusColor.backcolor.edgesIgnoringSafeArea(.all)
        VStack{
            HStack{
                Image(systemName: "arrow.left")
                .renderingMode(.original)
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(Color("primaryColor"))
                Text("Back")
                    .foregroundColor(Color("primaryColor"))
                    .font(.custom("VarelaRound-Regular", size: 18))
                   
        Spacer()
            }
            .padding()
           // Spacer()
            VStack{
            GeometryReader { geometry in
                      HStack {
                          Picker(selection: $selectedHours, label: Text("hrs")
                                    .font(.custom("Varela Round Regular", size: 18))
                                    .foregroundColor(Color("primaryColor"))) {
                              ForEach(0..<self.hours.count) {
                                  Text("\(self.hours[$0]) hrs")
                                  
                                     // .bold()
                                      .font(.custom("VarelaRound-Regular", size: 18))
                                      .foregroundColor(Color("primaryColor"))
                              }
                          }
                          .frame(maxWidth: geometry.size.width / 2)
                          .clipped()
                          .pickerStyle(.wheel)
                          
                          Picker(selection: self.$selectedMins, label: Text("mins")) {
                              ForEach(0..<self.min.count) {
                                  Text("\(self.min[$0]) mins")
                                      //.bold()
                                      .font(.custom("VarelaRound-Regular", size: 18))
                                      .foregroundColor(Color("primaryColor"))
                              }
                          }
                          .frame(maxWidth: geometry.size.width / 2)
                          .clipped()
                          .pickerStyle(.wheel)
                      }
                  }
                  .offset(y: -100)
                  .padding()
                  .frame(width: .infinity, height: 140, alignment: .center)
            }
            .padding(.top, 100.0)
            
           
                  
            Text("Run Duration: \(selectedHours) Hours and \(selectedMins) Minutes ")
                .font(.custom("VarelaRound-Regular", size: 18))
                .foregroundColor(Color("primaryColor"))
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
               
            
            Button(action:{
            }, label: {
                Text("Submit")
                    .fontWeight(.bold)
                    .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
                    .font(.custom("VarelaRound-Regular", size: 18))
                    .background(CusColor.primarycolor)
                    .clipShape(Capsule())
            })
            Spacer()
        }
    }
}
}

struct SelectTimeView_Previews: PreviewProvider {
    static var previews: some View {

        SelectTimeView( )
    }
}
