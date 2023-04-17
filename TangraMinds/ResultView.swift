//
//  ResultView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 4/16/23.
//

//import SwiftUI
//
//struct ResultView: View {
//    @ObservedObject var bluetoothManager: BluetoothManager
//
//    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
//
//    let requiredData: Set<String> = [
//        "3034413945454231373030303030",
//        "3034414245454231373030303030",
//        "3034413845454231373030303030",
//        "3034413745454231373030303030"
//    ]
//
//    var shouldShowImages: Bool {
//        Set(bluetoothManager.receivedData).intersection(requiredData).count == requiredData.count
//    }
//
//    var body: some View {
//        if shouldShowImages {
//            ScrollView {
//                LazyVGrid(columns: gridItems, spacing: 20) {
//                    Image("fish")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//
//                    Image("ferry")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//
//                    Image("hill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//
//                    Image("tree")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//                }
//                .padding()
//            }
//        } else {
//            Text("Please Select Some Tangras")
//        }
//    }
//}
//
//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView(bluetoothManager: BluetoothManager())
//    }
//}
// ResultView.swift
// ResultView.swift
import SwiftUI

struct ResultView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var selectedImage: String?
    @State private var isGalleryViewPresented = false

    let images: [String] = ["fish", "ferry", "hill", "tree"]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedImage == image ? Color.blue : Color.clear, lineWidth: 4)
                            )
                            .onTapGesture {
                                if selectedImage == image {
                                    selectedImage = nil
                                } else {
                                    selectedImage = image
                                }
                            }
                    }
                }
                .padding()
            }
            Button(action: {
                isGalleryViewPresented = true
            }) {
                Text("Done")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedImage == nil)
            .sheet(isPresented: $isGalleryViewPresented) {
                GalleryView()
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(bluetoothManager: BluetoothManager())
    }
}
