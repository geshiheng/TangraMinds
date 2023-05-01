//
//  GalleryView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/1/23.
//

// GalleryView.swift
import SwiftUI

struct GalleryView: View {
    @State private var isCameraViewPresented = false
    @State private var isPhotoLibraryViewPresented = false
    @StateObject private var databaseManager = DatabaseManagerWrapper.shared.databaseManager!
    @State private var tangramClassifier = TangramClassifier()
    
    @State private var isClassificationButtonEnabled = false

    var body: some View {
        VStack {
            Text("Gallery View")
                .font(.largeTitle)
                .padding()

            Button(action: {
                isCameraViewPresented = true
            }) {
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $isCameraViewPresented) {
                CameraView(databaseManager: databaseManager)
            }

            Button(action: {
                isPhotoLibraryViewPresented = true
            }) {
                Text("Gallery")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isPhotoLibraryViewPresented) {
                PhotoLibraryView(databaseManager: databaseManager, tangramClassifier: tangramClassifier)
            }


        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}




