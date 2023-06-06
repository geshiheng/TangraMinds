//
//  PickingView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/3/23.
//

import SwiftUI

struct PickingView: View {
    @Binding var selectedImage: String?
    @ObservedObject var bluetoothManager: BluetoothManager

    func sendStart() {
        let data = Data(hex: "636F6D706C65746564")
        bluetoothManager.sendData(data)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Selected Image:")
                if let image = selectedImage {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                } else {
                    Text("No image selected.")
                }
                
                Button(action: sendStart) {
                    Text("Start")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $bluetoothManager.shouldNavigateToSuccessfulView) {
                    SuccessfulView()
                }
            }
        }
    }
}


struct PickingView_Previews: PreviewProvider {
    static var previews: some View {
        PickingView(selectedImage: .constant("house 1"), bluetoothManager: BluetoothManager())
    }
}
