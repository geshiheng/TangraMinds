//
//  SelectedPhotoView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/5/23.
//

import SwiftUI

struct SelectedPhotoView: View {
    @Binding var selectedImage: String?  // 添加一个@Binding修饰符的属性
    @State private var showGalleryView = false // 添加状态变量以显示GalleryView

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("No image selected")
            }

            Button(action: {
                self.showGalleryView = true
            }) {
                Text("Done")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showGalleryView) {
                GalleryView()
            }
        }
    }
}

struct SelectedPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPhotoView(selectedImage: .constant("chicken")) // 提供一个默认值进行预览
    }
}
