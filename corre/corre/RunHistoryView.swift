//
//  RunHistoryView.swift
//  Corre-RunningMap
//
//  Created by Danielle Nau on 3/24/22.
//

import SwiftUI

struct RunHistory: Identifiable {
    
    let id = UUID()
    let date: String
    let location: String
    
    let StartTime: String
    let EndTime: String
    let distance: String
    let avg_speed: String
    
}

// A view that shows the data for one RunHistory.
struct RunHistoryRow: View {
    var RunHistory: RunHistory
    
    var body: some View {
        Section(header: Text("\(RunHistory.date)")  .foregroundColor(Color.gray)
            .font(.custom("Varela Round Regular", size: 14))){
        Text("Location: \(RunHistory.location)")
        Text("StartTime: \(RunHistory.StartTime)")
        Text("EndTime: \(RunHistory.EndTime)")
        Text("Distance: \(RunHistory.distance)")
        Text("Average Speed: \(RunHistory.avg_speed)")
        }
        .foregroundColor(Color("primaryColor"))
        .listRowBackground(Color("lightBlue"))
        .font(.custom("Varela Round Regular", size: 18))
        
        
       
    }
}

struct RunHistoryView: View {
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    let history = [
        RunHistory(date: "March 24, 2022 ", location: "Orlando, FL", StartTime: " 9:00 AM", EndTime: " 10:00 AM", distance: "1 mi", avg_speed:"5 ms"),
        RunHistory(date: "March 23, 2022 ", location: "Orlando, FL", StartTime: " 7:00 AM", EndTime: " 8:30 AM", distance: "0.7 mi", avg_speed:"4 ms"),
        RunHistory(date: "March 20, 2022 ", location: "Orlando, FL", StartTime: " 4:00 PM", EndTime: " 4:45 PM", distance: "0.7 mi", avg_speed:"4 ms")
       
          
       ]
    init() {
            UITableView.appearance().backgroundColor = .clear
        }
        
        
    var body: some View {
        ZStack{
            CusColor.backcolor.edgesIgnoringSafeArea(.all)
        VStack{
            HStack{
                Button (action: {}){
                Image(systemName: "arrow.left")
                .renderingMode(.original)
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(Color("primaryColor"))
                Text("Run History")
                    .foregroundColor(Color("primaryColor"))
                    .font(.custom("Varela Round Regular", size: 17))
       
            }
                Spacer()
            }
            .padding()
            
            VStack{
            List(history, rowContent: RunHistoryRow.init)
                   // .shadow(radius: 1)
                   
            }
            //.frame(height: 650)
            Spacer()
           // .padding()
        
        
        
        }
    }
}
}

struct RunHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RunHistoryView()
    }
}

