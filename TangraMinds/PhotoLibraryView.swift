//
//  PhotoLibraryView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/1/23.
//
// PhotoLibraryView.swift
import SwiftUI
import Photos

struct PhotoLibraryView: View {
    @State private var images: [UIImage] = []

    var body: some View {
        VStack {
            Text("Photo Library")
                .font(.largeTitle)
                .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: loadImages)
    }

    func loadImages() {
        requestPhotoLibraryAuthorization { authorized in
            if authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                DispatchQueue.global(qos: .userInitiated).async {
                    let imageManager = PHImageManager.default()
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.isSynchronous = true

                    assets.enumerateObjects { asset, _, _ in
                        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: requestOptions) { image, _ in
                            if let image = image {
                                DispatchQueue.main.async {
                                    images.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func requestPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
}

struct PhotoLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoLibraryView()
    }
}
