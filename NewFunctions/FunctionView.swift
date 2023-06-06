//
//  FunctionView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/1/23.
//

import SwiftUI

struct ButtonLabel: View {
    let label: String
    var body: some View {
        Text(label)
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct FunctionView: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    @State private var showNewLearnerView = false
    @State private var showSmartBuilderView = false
    @State private var showFreeformArtistryView = false
    @State private var showPuzzleMasterView = false
    @State private var showMasterpieceShowcase = false

    func sendNewLearnerData() {
        let data = Data(hex: "6E65776C6561726E6572")
        bluetoothManager.sendData(data)
    }

    func sendSmartBuilderData() {
        let data = Data(hex: "736D6172746275696C646572")
        bluetoothManager.sendData(data)
    }

    func sendFreeformArtistryData() {
        let data = Data(hex: "66726565666F726D6172746973747279")
        bluetoothManager.sendData(data)
    }

    func sendPuzzleMasterData() {
        let data = Data(hex: "70757A7A6C656D6173746572")
        bluetoothManager.sendData(data)
    }

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                sendNewLearnerData()
                showNewLearnerView = true
            }) {
                ButtonLabel(label: "New Learner")
            }.sheet(isPresented: $showNewLearnerView) {
                NewLearnerView(bluetoothManager: bluetoothManager)
            }

            Button(action: {
                sendSmartBuilderData()
                showSmartBuilderView = true
            }) {
                ButtonLabel(label: "Smart Builder")
            }.sheet(isPresented: $showSmartBuilderView) {
                SmartBuilderView(bluetoothManager: bluetoothManager)
            }

            Button(action: {
                sendFreeformArtistryData()
                showFreeformArtistryView = true
            }) {
                ButtonLabel(label: "Freeform Artistry")
            }.sheet(isPresented: $showFreeformArtistryView) {
                FreeformArtistryView()
            }

            Button(action: {
                sendPuzzleMasterData()
                showPuzzleMasterView = true
            }) {
                ButtonLabel(label: "Puzzle Master")
            }.sheet(isPresented: $showPuzzleMasterView) {
                PuzzleMasterView()
            }

            // 省略其他代码
        }
    }
}

struct FunctionView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionView(bluetoothManager: BluetoothManager())
    }
}
