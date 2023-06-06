//
//  NewLearnerView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/1/23.
//

import SwiftUI

struct NewLearnerView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    
    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("New Learner")
                    .font(.largeTitle)
                    .padding()
                
                Text("In this mode, we will present a nearly complete shape - your mission is to find the missing piece. Once you've completed the puzzle correctly, the canvas lights up as your reward!")
                    .font(.title)
                    .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        // Back button action
                    }) {
                        Text("Back")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {
                        isShowingSheet = true
                    }) {
                        Text("Go")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $isShowingSheet) {
                        LearnerPickView(bluetoothManager: bluetoothManager)
                    }
                }
            }
        }
    }
}

struct NewLearnerView_Previews: PreviewProvider {
    static var previews: some View {
        let bluetoothManager = BluetoothManager()
        NewLearnerView(bluetoothManager: bluetoothManager)
    }
}
