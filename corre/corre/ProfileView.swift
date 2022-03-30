//
//  ProfileView.swift
//  corre
//
//  Skeleton
//  Created by Mariana Botero on 2/7/22.
//
//
//  ProfileView.swift
//  Profile-page
//
//  Created by Danielle Nau on 2/3/22.
//
//  Modified by Lucas Morehouse on 2/10/22.
//  Modified by Lucas Morehouse on 2/12/22.

import SwiftUI
import PhotosUI

struct ProfileView: View {

    @State private var image = UIImage()
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
        if !editing {
            VStack {
                HStack{
                    Button (action: {
                            sessionManager.showSession()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .renderingMode(.original)
                            .edgesIgnoringSafeArea(.all)
                            .foregroundColor(Color("primaryColor"))
                        Text("Back")
                            .font(.custom("Varela Round Regular", size: 18))
                            .foregroundColor(Color("primaryColor"))
                        })
                        Spacer()
                        .foregroundColor(Color("primaryColor"))
                        
            
                        Button (action: {
                            sessionManager.signOut()
                        }){
                            Text("Sign Out")
                                .font(.custom("Varela Round Regular", size: 18))
                                .foregroundColor(Color.red)
                        }
                    }
                    .padding(.all)
            
            Image("CreamLogo")
                .resizable()
                .frame(width: 125.0, height: 125.0)
                .scaledToFit()
                .shadow(radius: 2)
                            
            Text("Profile Page")
                .font(.custom("Varela Round Regular", size: 22))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                
            Button (action: {
                self.editing = !self.editing
            }){
                Text("Edit")
                    .font(.custom("Varela Round Regular", size: 17))
                    .foregroundColor(Color.blue)
            }
            
                
            VStack{
                HStack{
                    Text("Name: \(user?.firstName ?? "") \(user?.lastName ?? "")")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Username: \(user?.username ?? "ERROR")")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Distance: \(user?.totalDistance ?? 0.0)")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Runs: \(user?.Runs?.count ?? 0)")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()

                HStack{
                    Text("Bio: \(user?.bio ?? "")")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                    Spacer()
                }
    
                List{
                    ForEach(sessionManager.databaseManager.runs, id: \.id) { run in
                        VStack {
                            Text(" ")
                            
                            // MARK: frontend help! super ugly!
                            Text("Date: 03/31/22 (placeholder)")
//                            Text("Date: \(String(describing: run.createdAt!.foundationDate))")
                                .listRowBackground(Color("orange"))
                                .foregroundColor(Color("primaryColor"))
                                .font(Font.custom("VarelaRound-Regular", size: 18))
                                
                            Text("Distance: \(run.distance) m")
                                .listRowBackground(Color("orange"))
                                .foregroundColor(Color("primaryColor"))
                                .font(Font.custom("VarelaRound-Regular", size: 18))
                                
                            Text("Average Speed: \(run.averageSpeed!) m/s")
                                .listRowBackground(Color("orange"))
                                .foregroundColor(Color("primaryColor"))
                                .font(Font.custom("VarelaRound-Regular", size: 18))
                            
                            Text(" ")
                        }
                    }
                }
                
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
        } else {
            VStack {
                HStack{
                    Button (action: {
                            sessionManager.showSession()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .renderingMode(.original)
                            .edgesIgnoringSafeArea(.all)
                            .foregroundColor(Color("primaryColor"))
                        Text("Back")
                            .font(.custom("Varela Round Regular", size: 18))
                            .foregroundColor(Color("primaryColor"))
                        })
                        Spacer()
                        .foregroundColor(Color("primaryColor"))
                }
                .padding(.all)
                
                Image("CreamLogo")
                    .resizable()
                    .frame(width: 125.0, height: 125.0)
                    .scaledToFit()
                    .shadow(radius: 2)
                                    
                Text("Profile Page")
                    .font(.custom("Varela Round Regular", size: 22))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(" ")
                    .font(.custom("Varela Round Regular", size: 16))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

            VStack{
                HStack{
                    Text("Name: \(user?.firstName ?? "") \(user?.lastName ?? "")")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Username: \(user?.username ?? "ERROR")")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Distance: \(user?.totalDistance ?? 0.0)")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Runs: \(user?.Runs?.count ?? 0)")
                        .foregroundColor(Color("primaryColor"))
                        .font(.custom("Varela Round Regular", size: 20))
                    Spacer()
                }
                    Divider()

                HStack{
                    Text("Bio: ")
                        .font(.custom("Varela Round Regular", size: 20))
                        .foregroundColor(Color("primaryColor"))
                    TextField("\(user?.bio ?? "No Bio")", text: $bio)
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom:0, trailing: 20))

            Spacer()
            HStack{
                Button(action: {
                    self.editing = !self.editing
                }, label: {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .font(.custom("Varela Round Regular", size: 18))
                        .padding()
                        .padding(.horizontal, 25)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                        .shadow(radius: 2)
                })
                    
                Button(action: {
                    self.updateUserRecord()
                }, label: {
                    Text("Save")
                        .fontWeight(.bold)
                        .font(.custom("Varela Round Regular", size: 18))
                        .padding()
                        .padding(.horizontal, 35)
                        .background(Color("primaryColor"))
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                        .shadow(radius: 2)
                })
            }
            Spacer()
        }
        .background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
                if sessionManager.databaseManager.currentUser == nil {
                    sessionManager.getCurrentAuthUser()
                }
                self.firstName = user?.firstName ?? ""
                self.lastName = user?.lastName ?? ""
                self.bio = user?.bio ?? ""
            })
        }
    }
    
    func updateUserRecord() {
        if self.bio == "No Bio" {
            self.bio = ""
        }
        var updateUser = sessionManager.databaseManager.currentUser!
        updateUser.bio = self.bio
        
        updateUser.firstName = self.firstName
        updateUser.lastName = self.lastName
        sessionManager.databaseManager.updateUserProfile(updatedUser: updateUser)
        self.user = sessionManager.databaseManager.currentUser
        self.editing = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        let testUsr = User(id: "000", sub: "000", username: "Test", bio: "Test Bio", totalDistance: 0.0 ,firstName: "Test", lastName: "User", email: "TESTEMAIL PLACEHOLDER")
        ProfileView(user: testUsr)
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
