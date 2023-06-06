//
//  TangraMindsApp.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 4/15/23.
//

import SwiftUI

@main
struct TangraMindsApp: App {
    @StateObject var bluetoothManager = BluetoothManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bluetoothManager)
        }
    }
}
