//
//  ContentView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 4/15/23.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @State private var isCameraViewPresented = false
    @State private var centralManager: CBCentralManager?
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var isBluetoothDevicesViewPresented = false
    @State private var isResultViewPresented: Bool = false
    @State private var toastMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                isCameraViewPresented = true
            }) {
                Text("Detect")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isCameraViewPresented) {
                CameraView()
            }

            Button(action: {
                bluetoothManager.initializeCentralManager()
                isBluetoothDevicesViewPresented = true
            }) {
                Text("Open Bluetooth")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isBluetoothDevicesViewPresented) {
                BluetoothDevicesView(bluetoothManager: bluetoothManager)
            }
            
            Button(action: {
                isResultViewPresented = true
            }) {
                Text("Suggestions")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isResultViewPresented) {
                ResultView(bluetoothManager: bluetoothManager)
            }

            
        }
        .overlay(
            Group {
                if let message = bluetoothManager.toastMessage {
                    Toast(message: message)
                        .padding(.top, 50)
                        .animation(.easeInOut)
                        .transition(.move(edge: .top))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    bluetoothManager.toastMessage = nil
                                }
                            }
                        }
                }
            }
        )
        .onChange(of: bluetoothManager.receivedDataCount) { count in
            if count == 4 {
                isResultViewPresented = true
            }
        }
    }
}


class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private(set) var centralManager: CBCentralManager?
    @Published var foundDevices: [CBPeripheral] = []
    private var connectedPeripheral: CBPeripheral?
    @Published var receivedData: [String] = []
    
    @Published var toastMessage: String?
    @Published var receivedDataCount: Int = 0



    func initializeCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // 开始扫描附近的蓝牙设备
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            // 停止扫描
            centralManager?.stopScan()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // 在这里处理发现的蓝牙设备，例如添加到找到的设备列表中
        if !foundDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            foundDevices.append(peripheral)
        }
    }

    func connectToDevice(_ peripheral: CBPeripheral) {
        if let centralManager = centralManager {
            // 停止扫描
            centralManager.stopScan()

            // 连接到设备
            connectedPeripheral = peripheral
            connectedPeripheral?.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("已连接到蓝牙设备：", peripheral.name ?? "未知设备")

        // 在这里添加你的代码，例如发现设备上的服务
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接蓝牙设备失败：", error?.localizedDescription ?? "未知错误")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("发现服务失败：", error.localizedDescription)
        } else {
            // 在这里处理发现的服务，例如发现特征
            if let services = peripheral.services {
                for service in services {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        if let error = error {
//            print("发现特征失败：", error.localizedDescription)
//        } else {
//            // 在这里处理发现的特征，例如读取和写入特征值等
//            if let characteristics = service.characteristics {
//                for characteristic in characteristics {
//                    print("发现特征：", characteristic)
//                }
//            }
//        }
//    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("发现特征失败：", error.localizedDescription)
        } else {
            // 在这里处理发现的特征，例如读取和写入特征值等
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    print("发现特征：", characteristic)

                    if characteristic.properties.contains(.notify) {
                        peripheral.setNotifyValue(true, for: characteristic)
                    }
                }
            }
        }
    }

    
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("读取特征值失败：\(error.localizedDescription)")
//            return
//        }
//
//        if let value = characteristic.value {
//            print("特征值更新：\(value)")
//            // 在这里处理新的特征值
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("读取特征值失败：\(error.localizedDescription)")
//            return
//        }
//
//        if let data = characteristic.value {
//            let hexString = data.map { String(format: "%02X", $0) }.joined()
//            print("特征值更新：\(data)")
//            print("十六进制字符串：\(hexString)")
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("读取特征值失败：\(error.localizedDescription)")
//            return
//        }
//
//        if let data = characteristic.value {
//            let hexString = data.map { String(format: "%02X", $0) }.joined()
//            print("特征值更新：\(data)")
//            print("十六进制字符串：\(hexString)")
//
//            if !receivedData.contains(hexString) {
//                receivedData.append(hexString)
//            }
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("读取特征值失败：\(error.localizedDescription)")
//            return
//        }
//
//        if let value = characteristic.value {
//            print("特征值更新：\(value)")
//            let hexString = value.map { String(format: "%02X", $0) }.joined()
//            switch hexString {
//            case "3034413745454231373030303030":
//                toastMessage = "You have selected a square"
//            case "3034413845454231373030303030":
//                toastMessage = "You selected small triangle"
//            case "3034414245454231373030303030":
//                toastMessage = "You selected the large triangle 1"
//            case "3034413945454231373030303030":
//                toastMessage = "You selected the large triangle 2"
//            default:
//                break
//            }
//        }
//    }

//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("读取特征值失败：\(error.localizedDescription)")
//            return
//        }
//
//        if let value = characteristic.value {
//            print("特征值更新：\(value)")
//            let hexString = value.map { String(format: "%02X", $0) }.joined()
//            switch hexString {
//            case "3034413745454231373030303030":
//                toastMessage = "您选择了正方形"
//                receivedDataCount += 1
//            case "3034413845454231373030303030":
//                toastMessage = "您选择了小三角形"
//                receivedDataCount += 1
//            case "3034414245454231373030303030":
//                toastMessage = "您选择了大三角形1"
//                receivedDataCount += 1
//            case "3034413945454231373030303030":
//                toastMessage = "您选择了大三角形2"
//                receivedDataCount += 1
//            default:
//                break
//            }
//        }
//    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("读取特征值失败：\(error.localizedDescription)")
            return
        }

        if let value = characteristic.value {
            print("特征值更新：\(value)")
            let hexString = value.map { String(format: "%02X", $0) }.joined()
            receivedData.append(hexString) // 将接收到的数据添加到 receivedData 数组中
            switch hexString {
            case "3034413745454231373030303030":
                toastMessage = "You have selected a square"
                receivedDataCount += 1
            case "3034413845454231373030303030":
                toastMessage = "You selected small triangle"
                receivedDataCount += 1
            case "3034414245454231373030303030":
                toastMessage = "You selected the large triangle 1"
                receivedDataCount += 1
            case "3034413945454231373030303030":
                toastMessage = "You selected the large triangle 2"
                receivedDataCount += 1
            default:
                break
            }
        }
    }

    
    func readValue(for characteristic: CBCharacteristic) {
        guard let peripheral = connectedPeripheral else { return }
        peripheral.readValue(for: characteristic)
    }


    // 在这里添加其他代理方法以处理更多的蓝牙操作，如发现特征、读取和写入特征值等
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
