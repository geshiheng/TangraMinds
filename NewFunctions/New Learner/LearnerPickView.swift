//
//  LearnerPickView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/2/23.
//

import SwiftUI

struct LearnerPickView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var selectedImage: String?
    @State private var showPickingView = false

    let images = ["rocket", "tree 1", "house 1"]

    var body: some View {
        VStack {
            // Display the four images
            ForEach(images, id: \.self) { image in
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        self.selectedImage = image
                    }
                    .opacity(self.selectedImage == image ? 1.0 : 0.6)
                    .padding()
            }
            // Add the Done button
            
            
            Button(action: {
                self.showPickingView = true
                
            }) {
                Text("Done")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedImage == nil)  // Disable the button if no image is selected
        }
        .sheet(isPresented: $showPickingView) {
            PickingView(selectedImage: self.$selectedImage, bluetoothManager: bluetoothManager)
        }
    }
}

struct LearnerPickView_Previews: PreviewProvider {
    static var previews: some View {
        // Assuming a BluetoothManager instance exists for preview
        let bluetoothManager = BluetoothManager()
        LearnerPickView(bluetoothManager: bluetoothManager)
    }
}


