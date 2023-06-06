//
//  PuzzlePickView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/2/23.
//

import SwiftUI

struct PuzzlePickView: View {
    @State private var selectedImage: String?
    @State private var showGalleryView = false

    let images = ["chicken", "horse", "snail", "swan"]

    var body: some View {
        VStack {
            // Display the four images in 2x2 grid
            HStack {
                ForEach(images[0..<2], id: \.self) { image in
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            self.selectedImage = image
                        }
                        .opacity(self.selectedImage == image ? 1.0 : 0.6)
                        .padding()
                }
            }
            HStack {
                ForEach(images[2..<4], id: \.self) { image in
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            self.selectedImage = image
                        }
                        .opacity(self.selectedImage == image ? 1.0 : 0.6)
                        .padding()
                }
            }
            // Add the Done button
            Button(action: {
                if selectedImage != nil {
                    self.showGalleryView = true
                }
            }) {
                Text("Done")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedImage == nil)  // Disable the button if no image is selected
            .padding()
        }
        .sheet(isPresented: $showGalleryView) {
            SelectedPhotoView(selectedImage: self.$selectedImage)
        }

    }
}

struct PuzzlePickView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PuzzlePickView()
        }
    }
}



