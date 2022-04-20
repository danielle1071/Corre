//
//  RunHistoryView.swift
//  Corre-RunningMap
//
//  Created by Danielle Nau on 3/24/22.
//

import SwiftUI
/*
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
    var RunHistory: Run
    
    var body: some View {
        Section(header: Text("Run")
            .foregroundColor(Color.gray)
            .font(.custom("Varela Round Regular", size: 14))) {
                Text("Distance: \(RunHistory.distance)")
                // Text("Average Speed: \(RunHistory.averageSpeed)")
            }
        .foregroundColor(Color("primaryColor"))
        .listRowBackground(Color("lightBlue"))
        .font(.custom("Varela Round Regular", size: 18))
        
        
       
    }
}

struct RunHistoryView: View {
    @EnvironmentObject var sessionManager: SessionManger
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    
    let history = [Run]()

    init() {
            UITableView.appearance().backgroundColor = .clear
            self.history = sessionManager.databaseManager.runs
        }
    
    
        
        
    var body: some View {
        ZStack{
            CusColor.backcolor.edgesIgnoringSafeArea(.all)
        VStack{
            
//            HStack{
//                Button (action: {}){
//                Image(systemName: "arrow.left")
//                .renderingMode(.original)
//                .edgesIgnoringSafeArea(.all)
//                .foregroundColor(Color("primaryColor"))
//                Text("Run History")
//                    .foregroundColor(Color("primaryColor"))
//                    .font(.custom("Varela Round Regular", size: 17))
//
//            }
//                Spacer()
//            }
//            .padding()
            
            
            VStack{
            Text("Run History")
                    .font(.custom("Varela Round Regular", size: 17))
                    .padding([.bottom], -7)

            List(history, rowContent: RunHistoryRow.init)

                   // .shadow(radius: 1)
                   
            }
            .padding([.top], -33)
            .frame(height: 620)
//            Spacer()
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
 */

struct RunHistoryView: View {
    @State private var showSheet = false
    
    @State var editing = false
    @State var bio = ""
    @State var firstName = ""
    @State var lastName = ""
    @EnvironmentObject var sessionManager: SessionManger
    @State var user:User?
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")

        static let primarycolor = Color("primaryColor")

        static let lblue = Color("lightBlue")
    }
    var body: some View {
            VStack {
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
                            
            Text("Run Stats")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("primaryColor"))
                
           /*
                Button (action: {
                self.editing = !self.editing
            }){
                Text("Edit")
                    .font(.custom("Varela Round Regular", size: 17))
                    .foregroundColor(Color("primaryColor"))
            }
            */
                
            VStack{
                List{
                    ForEach(sessionManager.databaseManager.runs, id: \.id) { run in
                        Section(header: Text("\(run.createdAt?.foundationDate.formatted() ?? "DATE NOT SAVED")")) {
                            //Text(" ")
                            Text("Duration: \((run.distance / (run.averageSpeed ?? 1.0)) / 60, specifier: "%.2f") minutes")
                                .listRowBackground(Color("orange"))
                                .foregroundColor(Color("primaryColor"))
                                .font(Font.custom("VarelaRound-Regular", size: 18))
                                
                            Text("Distance: \(run.distance, specifier: "%.2f") m")
                                .listRowBackground(Color("orange"))
                                .foregroundColor(Color("primaryColor"))
                                .font(Font.custom("VarelaRound-Regular", size: 18))
                              
                            Text("Average Speed: \(run.averageSpeed ?? 0.0, specifier: "%.2f") m/s")
                                .listRowBackground(Color("orange"))
                                .foregroundColor(Color("primaryColor"))
                                .font(Font.custom("VarelaRound-Regular", size: 18))
                            
                            //Text(" ")
                        }
                    }
                }
               // .listRowBackground(Color("orange"))
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom:0, trailing: 20))

            Spacer()
//                Button("Sign Out", action: {
//                                sessionManager.signOut()
//                            }).padding()
//                                .padding(.horizontal, 100)
//                                .foregroundColor(CustomColor.primarycolor)
//                                .background(CustomColor.backcolor)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 20)
//                                    .stroke(CustomColor.primarycolor, lineWidth: 2)
//                                )
            }
            .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
            .onAppear(perform: {
                if sessionManager.databaseManager.currentUser == nil {
                    sessionManager.getCurrentAuthUser()
                }
                self.user = sessionManager.databaseManager.currentUser
            })
    }
}



