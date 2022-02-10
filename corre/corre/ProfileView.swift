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

import SwiftUI
import PhotosUI

struct ProfileView: View {

    @State private var image = UIImage()
    @State private var showSheet = false
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
            .foregroundColor(Color("primaryColor"))

        Text("Profile Page")
            .foregroundColor(Color("primaryColor"))

            Spacer()
            }
    .padding()

        VStack{

        Image(uiImage: self.image)
                .resizable()
                .cornerRadius(50)
                .padding(.all, 4)
                .frame(width: 100, height: 100)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .padding(8)


        Text("Change photo")
                .font(.headline)
                .frame(width: 150.0, height: 50)
                .background(Color("primaryColor"))
                .clipShape(Capsule())
                .foregroundColor(.white)
                .onTapGesture {
                    showSheet = true
                }
        }
        .padding(/*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
        .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
    }



    VStack{
    HStack{
        Text("Name:")
            .foregroundColor(Color("primaryColor"))
        Spacer()
    }
        Divider()
    HStack{
        Text("Username:")
            .foregroundColor(Color("primaryColor"))
        Spacer()
    }
        Divider()
    HStack{
        Text("Total Distance:")
            .foregroundColor(Color("primaryColor"))
        Spacer()
    }
        Divider()
    HStack{
        Text("Total Runs:")
            .foregroundColor(Color("primaryColor"))
        Spacer()
    }
        Divider()

    HStack{
        Text("Bio:")
            .foregroundColor(Color("primaryColor"))
        Spacer()
    }
    }
    .padding(EdgeInsets(top: 0, leading: 20, bottom:0, trailing: 20))

    Spacer()


        }
.background(CusColor.backcolor.edgesIgnoringSafeArea(.all))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
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
