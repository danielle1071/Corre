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


                    Text("Profile Page")
                        .foregroundColor(Color("primaryColor"))

                        Spacer()
                        }
                .padding()
                Button("Edit Bio", action: {
                    self.editing = !self.editing
                })
                

            VStack{
                HStack{
                    Text("Name: \(user?.firstName ?? "") \(user?.lastName ?? "")")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Username: \(user?.username ?? "ERROR")")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Distance: \(user?.totalDistance ?? 0.0)")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Runs: \(user?.Runs?.count ?? 0)")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()

                HStack{
                    Text("Bio: \(user?.bio ?? "")")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom:0, trailing: 20))

            Spacer()


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


                    Text("Profile Page")
                        .foregroundColor(Color("primaryColor"))

                        Spacer()
                        }
                .padding()
                Button("Cancel", action: {
                    self.editing = !self.editing
                })
                    .foregroundColor(Color.red)
                

            VStack{
                HStack{
                    Text("Name: \(user?.firstName ?? "") \(user?.lastName ?? "")")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Username: \(user?.username ?? "ERROR")")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Distance: \(user?.totalDistance ?? 0.0)")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()
                HStack{
                    Text("Total Runs: \(user?.Runs?.count ?? 0)")
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                    Divider()

                HStack{
                    Text("Bio: ")
                    TextField("\(user?.bio ?? "No Bio")", text: $bio)
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                Button("Save Bio", action: {
                    self.updateUserRecord()
                })

            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom:0, trailing: 20))

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
