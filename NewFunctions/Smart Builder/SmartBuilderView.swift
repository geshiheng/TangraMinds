//
//  SmartBuilderView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/1/23.
//

//import SwiftUI
//
//struct SmartBuilderView: View {
//    @StateObject var bluetoothManager: BluetoothManager
//
//    var body: some View {
//        VStack {
//            Text("Smart Builder")
//                .font(.largeTitle)
//                .padding()
//
//            Text("Simply pick the tangram pieces of your choice, and the app will provide personalized shape recommendations. Follow the recommendations to build your masterpiece. Scan your final work with the integrated camera to receive a matching score, helping you understand your precision and offering insights to improve. Get ready to harness your creativity under the guidance of our smart algorithm!")
//                .font(.title)
//                .padding()
//
//            Spacer()
//
//            HStack {
//                NavigationLink(destination: FunctionView()) {
//                    Text("Back")
//                        .font(.title)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//
//                NavigationLink(destination: BoardView(bluetoothManager: bluetoothManager)) {
//                    Text("Go")
//                        .font(.title)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//            }
//        }
//    }
//}
//
//struct SmartBuilderView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            SmartBuilderView(bluetoothManager: BluetoothManager())
//        }
//    }
//}

import SwiftUI

struct SmartBuilderView: View {
    @StateObject var bluetoothManager: BluetoothManager
    @State var showFunctionView = false
    @State var showBoardView = false

    var body: some View {
        VStack {
            Text("Smart Builder")
                .font(.largeTitle)
                .padding()
            
            Text("Simply pick the tangram pieces of your choice, and the app will provide personalized shape recommendations. Follow the recommendations to build your masterpiece. Scan your final work with the integrated camera to receive a matching score, helping you understand your precision and offering insights to improve. Get ready to harness your creativity under the guidance of our smart algorithm!")
                .font(.title)
                .padding()
            
            Spacer()
            
            HStack {
                Button(action: { showFunctionView.toggle() }) {
                    Text("Back")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showFunctionView) {
                    FunctionView(bluetoothManager: bluetoothManager)
                }

                Button(action: { showBoardView.toggle() }) {
                    Text("Go")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showBoardView) {
                    BoardView(bluetoothManager: bluetoothManager)
                }
            }
        }
    }
}

struct SmartBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SmartBuilderView(bluetoothManager: BluetoothManager())
        }
    }
}

