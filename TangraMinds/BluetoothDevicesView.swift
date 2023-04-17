//
//  BluetoothDevicesView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 4/15/23.
//

import SwiftUI
import CoreBluetooth

struct BluetoothDevicesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        NavigationView {
            List {
                ForEach(bluetoothManager.foundDevices, id: \.identifier) { device in
                    DeviceRow(device: device, connectAction: {
                        bluetoothManager.connectToDevice(device)
                    })
                }
            }
            .navigationBarTitle("Found Devices", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct DeviceRow: View {
    let device: CBPeripheral
    let connectAction: () -> Void

    var body: some View {
        if let deviceName = device.name {
            HStack {
                Text(deviceName)
                Spacer()
                Button(action: connectAction) {
                    Text("Connect")
                        .padding(.horizontal)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

// Bluetooth Preview
struct BluetoothDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothDevicesView(bluetoothManager: BluetoothManager())
    }
}
