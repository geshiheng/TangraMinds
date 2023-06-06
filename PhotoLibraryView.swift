//
//  PhotoLibraryView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/1/23.
//
// PhotoLibraryView.swift
import SwiftUI
import Photos

//struct PhotoLibraryView: View {
//    @State private var images: [UIImage] = []
//
//    var body: some View {
//        VStack {
//            Text("Photo Library")
//                .font(.largeTitle)
//                .padding()
//
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
//                    ForEach(images, id: \.self) { image in
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                    }
//                }
//                .padding()
//            }
//        }
//        .onAppear(perform: loadImages)
//    }
//
//    func loadImages() {
//        requestPhotoLibraryAuthorization { authorized in
//            if authorized {
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//
//                DispatchQueue.global(qos: .userInitiated).async {
//                    let imageManager = PHImageManager.default()
//                    let requestOptions = PHImageRequestOptions()
//                    requestOptions.isSynchronous = true
//
//                    assets.enumerateObjects { asset, _, _ in
//                        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: requestOptions) { image, _ in
//                            if let image = image {
//                                DispatchQueue.main.async {
//                                    images.append(image)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func requestPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
//        PHPhotoLibrary.requestAuthorization { status in
//            DispatchQueue.main.async {
//                completion(status == .authorized)
//            }
//        }
//    }
//}
//
//struct PhotoLibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoLibraryView()
//    }
//}

//import SwiftUI
//
//struct PhotoLibraryView: View {
//    @StateObject private var viewModel: PhotoLibraryViewModel
//
//    init(databaseManager: DatabaseManager) {
//        _viewModel = StateObject(wrappedValue: PhotoLibraryViewModel(databaseManager: databaseManager))
//    }
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
//                ForEach(viewModel.photos, id: \.self) { photo in
//                    Image(uiImage: photo)
//                        .resizable()
//                        .scaledToFit()
//                        .cornerRadius(10)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Photo Library")
//    }
//}
//
//struct PhotoLibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Replace with your actual DatabaseManager instance
//        let databaseManager = DatabaseManager()
//        PhotoLibraryView(databaseManager: databaseManager)
//    }
//}





//import SwiftUI
//
//struct PhotoLibraryView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject private var viewModel: PhotoLibraryViewModel
//    let databaseManager: DatabaseManager
//    let tangramClassifier: TangramClassifier
//
//    @Binding var isClassificationButtonEnabled: Bool
//
//    init(databaseManager: DatabaseManager, tangramClassifier: TangramClassifier, isClassificationButtonEnabled: Binding<Bool>) {
//        self.databaseManager = databaseManager
//        self.tangramClassifier = tangramClassifier
//        _viewModel = StateObject(wrappedValue: PhotoLibraryViewModel(databaseManager: databaseManager))
//        _isClassificationButtonEnabled = isClassificationButtonEnabled
//    }
//
//    var body: some View {
//        VStack {
//            if viewModel.photos.isEmpty {
//                Text("No photos in library")
//                    .font(.title)
//            } else {
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                        ForEach(viewModel.photos, id: \.self) { photo in
//                            Image(uiImage: photo)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(viewModel.selectedPhoto == photo ? Color.blue : Color.clear, lineWidth: 4)
//                                )
//                                .onTapGesture {
//                                    viewModel.selectedPhoto = photo
//                                    isClassificationButtonEnabled = viewModel.selectedPhoto != nil
//                                }
//                        }
//                    }
//                    .padding()
//                }
//            }
//        }
//    }
//}
//
//struct PhotoLibraryView_Previews: PreviewProvider {
//    @State static var isClassificationButtonEnabled = false
//
//    static var previews: some View {
//        if let tangramClassifier = TangramClassifier() {
//            PhotoLibraryView(databaseManager: DatabaseManager(), tangramClassifier: tangramClassifier, isClassificationButtonEnabled: $isClassificationButtonEnabled)
//        } else {
//            Text("Tangram Classifier not available")
//        }
//    }
//}
























import SwiftUI

struct PhotoLibraryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: PhotoLibraryViewModel
    let databaseManager: DatabaseManager
    let tangramClassifier: TangramClassifier
    @ObservedObject private var bluetoothManager: BluetoothManager


    @State private var classificationResult: String?

    init(databaseManager: DatabaseManager, tangramClassifier: TangramClassifier, bluetoothManager: BluetoothManager) {
        self.databaseManager = databaseManager
        self.tangramClassifier = tangramClassifier
        _viewModel = StateObject(wrappedValue: PhotoLibraryViewModel(databaseManager: databaseManager))
        self.bluetoothManager = bluetoothManager
    }


    var body: some View {
        VStack {
            if viewModel.photos.isEmpty {
                Text("No photos in library")
                    .font(.title)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.photos, id: \.self) { photo in
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(viewModel.selectedPhoto == photo ? Color.blue : Color.clear, lineWidth: 4)
                                )
                                .onTapGesture {
                                    viewModel.selectedPhoto = photo
                                }
                        }
                    }
                    .padding()
                }
            }

            Button(action: classifyImage) {
                Text("Classify")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.selectedPhoto == nil)

            Button(action: deleteAllPhotos) {
                Text("Delete All Photos")
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.photos.isEmpty)


            if let classification = classificationResult {
                Text("Classification: \(classification)")
                    .font(.title2)
                    .padding()
            }
        }
    }

    private func classifyImage() {
        guard let selectedPhoto = viewModel.selectedPhoto else {
            return
        }

        tangramClassifier.classify(image: selectedPhoto) { result in
            switch result {
            case .success(let classification):
                classificationResult = classification
                print("Classification: \(classification)")
                let data = Data(hex: "636F6D706C65746564")
                bluetoothManager.sendData(data)
            
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
//        let data = Data(hex: "636F6D706C65746564")
//        bluetoothManager.sendData(data)
    }
    private func deleteAllPhotos() {
        databaseManager.deleteAllPhotos()
        viewModel.photos = databaseManager.retrievePhotos()
    }

}

struct PhotoLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoLibraryView(databaseManager: DatabaseManager(), tangramClassifier: TangramClassifier(), bluetoothManager: BluetoothManager())
    }
}












//import SwiftUI
//import Vision
//
//struct PhotoLibraryView: View {
//
//    let photos = ["cat", "dog", "hill"]
//   // @State private var currentIndex: Int = 0
//    @State private var image: UIImage? = nil
//    @State private var classificationLabel: String = ""
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject private var viewModel: PhotoLibraryViewModel
//    let databaseManager: DatabaseManager
//   // let tangramClassifier: TangramClassifier
//    let model = TangramClassifier1()
//
//    private func performClassification() {
////        let currentImageName = photos[currentIndex]
////
////        guard let img = UIImage(named: currentImageName),
////              let resizedImage = img.resizeTo(size: CGSize(width: 299, height: 299)),
////              let buffer = resizedImage.toBuffer() else {
////            return
////        }
////        let output = try? model.prediction(image: buffer)
////
////
////        if let output = output {
////            self.classificationLabel = output.classLabel
////
////        }
//        guard let image = image,
//                      let resizedImage = image.resizeTo(size: CGSize(width: 299, height: 299)),
//                      let buffer = resizedImage.toBuffer() else {
//                    return
//                }
//
//                do {
//                    let model = try VNCoreMLModel(for: TangramClassifier1().model)
//                    let request = VNCoreMLRequest(model: model) {request, error in
//                        guard let results = request.results as? [VNClassificationObservation],
//                              let topResult = results.first else {
//                            return
//                        }
//                        DispatchQueue.main.async {
//                                            self.classificationLabel = topResult.identifier
//                                        }
//                    }
//
//                    let handler = VNImageRequestHandler(cvPixelBuffer: buffer)
//                    try handler.perform([request])
//                } catch {
//                    print("Error: \(error)")
//                }
//    }
//
//    @State private var classificationResult: String?
//
//    init(databaseManager: DatabaseManager, tangramClassifier: TangramClassifier) {
//        self.databaseManager = databaseManager
//        //self.tangramClassifier = tangramClassifier
//        _viewModel = StateObject(wrappedValue: PhotoLibraryViewModel(databaseManager: databaseManager))
//    }
//
//    var body: some View {
//        VStack {
//            if viewModel.photos.isEmpty {
//                Text("No photos in library")
//                    .font(.title)
//            } else {
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                        ForEach(viewModel.photos, id: \.self) { photo in
//                            Image(uiImage: photo)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(viewModel.selectedPhoto == photo ? Color.blue : Color.clear, lineWidth: 4)
//                                )
//                                .onTapGesture {
//                                    viewModel.selectedPhoto = photo
//                                }
//                        }
//                    }
//                    .padding()
//                }
//            }
//
////            Button(action: classifyImage) {
////                Text("Classify")
////                    .font(.title)
////                    .padding()
////                    .background(Color.blue)
////                    .foregroundColor(.white)
////                    .cornerRadius(10)
////            }
////            .disabled(viewModel.selectedPhoto == nil)
//
//            Button("Classify") {
//                self.performClassification()
//            }.font(.title)
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            .disabled(viewModel.selectedPhoto == nil)
//            Text(classificationLabel)
//                .font(.largeTitle)
//                .padding()
//
//            Button(action: deleteAllPhotos) {
//                Text("Delete All Photos")
//                    .font(.title)
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .disabled(viewModel.photos.isEmpty)
//
//
//            if let classification = classificationResult {
//                Text("Classification: \(classification)")
//                    .font(.title2)
//                    .padding()
//            }
//        }
//    }
//
////    private func classifyImage() {
////        guard let selectedPhoto = viewModel.selectedPhoto else {
////            return
////        }
////
////        tangramClassifier.classify(image: selectedPhoto) { result in
////            switch result {
////            case .success(let classification):
////                classificationResult = classification
////                print("Classification: \(classification)")
////            case .failure(let error):
////                print("Error: \(error.localizedDescription)")
////            }
////        }
////    }
//    private func deleteAllPhotos() {
//        databaseManager.deleteAllPhotos()
//        viewModel.photos = databaseManager.retrievePhotos()
//    }
//
//}
//
//struct PhotoLibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoLibraryView(databaseManager: DatabaseManager(), tangramClassifier: TangramClassifier())
//    }
//}
