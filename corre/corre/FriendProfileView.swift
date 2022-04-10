//
//  FriendProfileView.swift

//
//  Created by Danielle Nau on 3/25/22.
//

import SwiftUI

struct FriendProfileView: View {
    var DEBUG = true
    
    @State var friend: User
    @EnvironmentObject var sessionManager: SessionManger
    
    struct CusColor {
        static let backcolor =
            Color("backgroundColor")
        
        static let primarycolor = Color("primaryColor")
        
        static let lblue = Color("lightBlue")
    }
    @State private var popup = false
    var body: some View {
       
        ZStack{
            CusColor.backcolor.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                Button(action: {
                    sessionManager.showNavBar()
                    // sessionManager.showFriendView()
                }, label: {
                    Image(systemName: "arrow.left")
                        .renderingMode(.original)
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(Color("primaryColor"))
                    Text("Friends Profile")
                        .font(.custom("Varela Round Regular", size: 18))
                        .foregroundColor(Color("primaryColor"))
                })
                    Spacer()
                    Button (action: {
                        popup = true
                    }){
                        Image(systemName: "person.badge.minus")
                            .resizable()
                            .foregroundColor(Color.red)
                            .frame(width: 30.0, height: 30.0)
                            .scaledToFit()
                    }
                    .padding(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                    
                    .alert(isPresented: $popup) {
                            Alert(
                                title: Text("Confirm to remove friend"),
                                primaryButton: .default(
                                    Text("Cancel")
                                   
                                ),
                                secondaryButton: .destructive(
                                    Text("Remove")
                                    // how to add action below, include comma
                                   // ,  action:delete friend
                                )
                            )
                        }
                }
                .padding()
                
                HStack{
                    Text("\(friend.username)")
                       // .font(.title)
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 35))
                    Spacer()
                    Button (action: {
                        sessionManager.showMessage(friendId: friend.id)
                    }){
                    Image(systemName: "bubble.right.circle.fill")
                            .resizable()
                            .foregroundColor(Color("primaryColor"))
                            .frame(width: 35.0, height: 35.0)
                            .scaledToFit()
                    }
                    .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                }
                .padding()
                
                
         Section{
//             HStack{
//                 Text("Username: \(friend.username)")
//                     .foregroundColor(Color("primaryColor"))
//                 Spacer()
//             }
//                 Divider()
             HStack{
                 Text("Total Distance: \(friend.totalDistance ?? 0.0, specifier: "%.2f")")
                     .foregroundColor(Color("primaryColor"))
                 Spacer()
             }
                 Divider()
             HStack{
                 Text("Total Runs: \(friend.Runs?.count ?? 0)")
                     .foregroundColor(Color("primaryColor"))
                 Spacer()
             }
                 Divider()

             HStack{
                 Text("Bio: \(friend.bio ?? "")")
                     .foregroundColor(Color("primaryColor"))
                 Spacer()
             }
             
             List{
                 ForEach(sessionManager.databaseManager.friendRuns, id: \.id) { run in
                     VStack {
                         Text(" ")
                         Text("Distance: \(run.distance, specifier: "%.2f") m")
                             .listRowBackground(Color("orange"))
                             .foregroundColor(Color("primaryColor"))
                             .font(Font.custom("VarelaRound-Regular", size: 18))
                             .frame(maxWidth: .infinity, alignment: .center)
                             
                         Text("Average Speed: \(run.averageSpeed ?? 0.0, specifier: "%.2f") m/s")
                             .listRowBackground(Color("orange"))
                             .foregroundColor(Color("primaryColor"))
                             .font(Font.custom("VarelaRound-Regular", size: 18))
                             .frame(maxWidth: .infinity, alignment: .center)
                         Text(" ")
                     }
                 }
             }
         }
         .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
         .font(.custom("Varela Round Regular", size: 18))
                // .padding()
                Spacer()
            }
        }
        .onAppear(perform: {
            if (DEBUG) { print("FriendProfileView -> Data: \(friend)") }
            
            sessionManager.databaseManager.getFriendRunLogs(friendId: friend.id)
        })
    }
}

//struct FriendProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendProfileView(friend: User)
//    }
//}

