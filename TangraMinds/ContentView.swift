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
    @State private var isBoardViewPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
//                Button(action: {
//                    isCameraViewPresented = true
//                }) {
//                    Text("Detect")
//                        .font(.title)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .sheet(isPresented: $isCameraViewPresented) {
//                    CameraView()
//                }
                Text("TangraMinds")
                    .font(.system(size: 40))
                    .padding()
                    .foregroundColor(.black)
                
                Button(action: {
                    bluetoothManager.initializeCentralManager()
                    isBluetoothDevicesViewPresented = true
                }) {
                    Text("Bluetooth")
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

                NavigationLink(destination: BoardView(bluetoothManager: bluetoothManager)) {
                    Text("Board")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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
}



//class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
//    private(set) var centralManager: CBCentralManager?
//    @Published var foundDevices: [CBPeripheral] = []
//    private var connectedPeripheral: CBPeripheral?
//    @Published var receivedData: [String] = []
//
//    @Published var toastMessage: String?
//    @Published var receivedDataCount: Int = 0
//    @Published var savedPhotos: [UIImage] = []
//    private var targetCharacteristic: CBCharacteristic?
//
//
//    func initializeCentralManager() {
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//    }
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            // 开始扫描附近的蓝牙设备
//            centralManager?.scanForPeripherals(withServices: nil, options: nil)
//        } else {
//            // 停止扫描
//            centralManager?.stopScan()
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
//        // 在这里处理发现的蓝牙设备，例如添加到找到的设备列表中
//        if !foundDevices.contains(where: { $0.identifier == peripheral.identifier }) {
//            foundDevices.append(peripheral)
//        }
//    }
//
//    func connectToDevice(_ peripheral: CBPeripheral) {
//        if let centralManager = centralManager {
//            // 停止扫描
//            centralManager.stopScan()
//
//            // 连接到设备
//            connectedPeripheral = peripheral
//            connectedPeripheral?.delegate = self
//            centralManager.connect(peripheral, options: nil)
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("已连接到蓝牙设备：", peripheral.name ?? "未知设备")
//
//        // 在这里添加你的代码，例如发现设备上的服务
//        peripheral.discoverServices(nil)
//    }
//
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print("连接蓝牙设备失败：", error?.localizedDescription ?? "未知错误")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        if let error = error {
//            print("发现服务失败：", error.localizedDescription)
//        } else {
//            // 在这里处理发现的服务，例如发现特征
//            if let services = peripheral.services {
//                for service in services {
//                    peripheral.discoverCharacteristics(nil, for: service)
//                }
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        if let error = error {
//            print("发现特征失败：", error.localizedDescription)
//        } else {
//            // 在这里处理发现的特征，例如读取和写入特征值等
//            if let characteristics = service.characteristics {
//                for characteristic in characteristics {
//                    print("发现特征：", characteristic)
//
//                    if characteristic.properties.contains(.notify) {
//                        peripheral.setNotifyValue(true, for: characteristic)
//                    }
//                }
//            }
//        }
//    }
//
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("读取特征值失败：\(error.localizedDescription)")
//            return
//        }
//
//        if let value = characteristic.value {
//            print("特征值更新：\(value)")
//            let hexString = value.map { String(format: "%02X", $0) }.joined()
//            receivedData.append(hexString) // 将接收到的数据添加到 receivedData 数组中
//            switch hexString {
//            case "3034413745454231373030303030":
//                toastMessage = "You have selected a square"
//                receivedDataCount += 1
//            case "3034413845454231373030303030":
//                toastMessage = "You selected small triangle"
//                receivedDataCount += 1
//            case "3034414245454231373030303030":
//                toastMessage = "You selected the large triangle 1"
//                receivedDataCount += 1
//            case "3034413945454231373030303030":
//                toastMessage = "You selected the large triangle 2"
//                receivedDataCount += 1
//            default:
//                break
//            }
//        }
//    }
//
//
//    func readValue(for characteristic: CBCharacteristic) {
//        guard let peripheral = connectedPeripheral else { return }
//        peripheral.readValue(for: characteristic)
//    }
//
//
//    // 在这里添加其他代理方法以处理更多的蓝牙操作，如发现特征、读取和写入特征值等
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        if let error = error {
//            print("发现特征失败：", error.localizedDescription)
//        } else {
//            // 在这里处理发现的特征，例如读取和写入特征值等
//            if let characteristics = service.characteristics {
//                for characteristic in characteristics {
//                    print("发现特征：", characteristic)
//
//                    if characteristic.properties.contains(.notify) {
//                        peripheral.setNotifyValue(true, for: characteristic)
//                    }
//
//                    // Replace the UUID below with the UUID of the characteristic you want to use
//                    if characteristic.uuid == CBUUID(string: "YOUR_TARGET_CHARACTERISTIC_UUID") {
//                        targetCharacteristic = characteristic
//                    }
//                }
//            }
//        }
//    }
//
//    func sendData(_ data: Data) {
//        guard let connectedPeripheral = connectedPeripheral,
//              let characteristic = targetCharacteristic else { return }
//
//        connectedPeripheral.writeValue(data, for: characteristic, type: .withResponse)
//    }
//
//}

import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private(set) var centralManager: CBCentralManager?
    @Published var foundDevices: [CBPeripheral] = []
    private var connectedPeripheral: CBPeripheral?
    @Published var receivedData: String = ""
    @Published var toastMessage: String?
    @Published var receivedDataCount: Int = 0
    @Published var savedPhotos: [UIImage] = []
    @Published var receivedDataList: [String] = []
    
    
    
    private var targetCharacteristic: CBCharacteristic?

    func initializeCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            centralManager?.stopScan()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !foundDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            foundDevices.append(peripheral)
        }
    }

    func connectToDevice(_ peripheral: CBPeripheral) {
        if let centralManager = centralManager {
            centralManager.stopScan()
            connectedPeripheral = peripheral
            connectedPeripheral?.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("已连接到蓝牙设备：", peripheral.name ?? "未知设备")
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接蓝牙设备失败：", error?.localizedDescription ?? "未知错误")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("发现服务失败：", error.localizedDescription)
        } else {
            if let services = peripheral.services {
                for service in services {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("发现特征失败：", error.localizedDescription)
        } else {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    print("发现特征：", characteristic)

                    if characteristic.properties.contains(.notify) {
                        peripheral.setNotifyValue(true, for: characteristic)
                    }

                    let targetCharacteristicUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
                    if characteristic.uuid == targetCharacteristicUUID {
                        targetCharacteristic = characteristic
                    }
                }
            }
        }
    }

    
    
    

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("更新特征值失败：", error.localizedDescription)
        } else {
            if let data = characteristic.value {
                handleReceivedData(data)
            }
        }
    }
    
//    func checkAndUpdateSavedPhotos() {
//        let conditionOne: Set<String> = ["45303034303130383331464337453842",
//                                         "45303034303130383331464339354142",
//                                         "45303034303130383331464338333242",
//                                         "45303034303130383331464342333634"]
//
//        let conditionTwo: Set<String> = ["45303034303130383331464337453842",
//                                         "45303034303130383331464339354142",
//                                         "45303034303130383331464342333634",
//                                         "45303034303130383331464338393338"]
//
//        let receivedDataSet = Set(receivedDataList)
//
//        if receivedDataSet == conditionOne {
//            if let image = UIImage(named: "白橙红绿") {
//                savedPhotos.append(image)
//            }
//            receivedDataList = [] // 清空已接收的数据列表
//        } else if receivedDataSet == conditionTwo {
//            if let image = UIImage(named: "白橙绿蓝") {
//                savedPhotos.append(image)
//            }
//            receivedDataList = [] // 清空已接收的数据列表
//        }
//    }
    func checkAndUpdateSavedPhotos() {
        let conditionCombinations: [Set<String>: String] = [
            ["45303034303130383331464337453842", "45303034303130383331464339354142", "45303034303130383331464339414439", "45303034303130383331464342333634"]: "白橙黄绿",
            ["45303034303130383331464337453842", "45303034303130383331464338463742", "45303034303130383331464339354142", "45303034303130383331464342333634"]: "白粉橙绿",
            ["45303034303130383331464337453842", "45303034303130383331464338463742", "45303034303130383331464339414439", "45303034303130383331464339354142"]: "白粉黄橙",
            ["45303034303130383331464337453842", "45303034303130383331464338463742", "45303034303130383331464339414439", "45303034303130383331464338393338"]: "白粉黄蓝",
            ["45303034303130383331464337453842", "45303034303130383331464338333242", "45303034303130383331464338463742", "45303034303130383331464338393338"]: "白红粉蓝",
            ["45303034303130383331464337453842", "45303034303130383331464338393338", "45303034303130383331464338333242", "45303034303130383331464342333634"]: "白蓝红绿",
            ["45303034303130383331464337453842", "45303034303130383331464342333634", "45303034303130383331464338463742", "45303034303130383331464338393338"]: "白绿粉蓝",
            ["45303034303130383331464337453842", "45303034303130383331464342333634", "45303034303130383331464339414439", "45303034303130383331464338393338"]: "白绿黄蓝",
            ["45303034303130383331464338463742", "45303034303130383331464338393338", "45303034303130383331464339414439", "45303034303130383331464339354142"]: "粉蓝黄橙",
            ["45303034303130383331464338463742", "45303034303130383331464342333634", "45303034303130383331464339414439", "45303034303130383331464339354142"]: "粉绿黄橙",
            ["45303034303130383331464338333242", "45303034303130383331464338463742", "45303034303130383331464339414439", "45303034303130383331464339354142"]: "红粉黄橙",
            ["45303034303130383331464338333242", "45303034303130383331464342333634", "45303034303130383331464339414439", "45303034303130383331464338393338"]: "红绿黄蓝",
            ["45303034303130383331464338393338", "45303034303130383331464338333242", "45303034303130383331464339354142", "45303034303130383331464339414439"]: "蓝红橙黄",
            ["45303034303130383331464338393338", "45303034303130383331464338333242", "45303034303130383331464338463742", "45303034303130383331464339354142"]: "蓝红粉橙",
            ["45303034303130383331464338393338", "45303034303130383331464342333634", "45303034303130383331464339354142", "45303034303130383331464339414439"]: "蓝绿橙黄",
            ["45303034303130383331464338393338", "45303034303130383331464342333634", "45303034303130383331464338463742", "45303034303130383331464339414439"]: "蓝绿粉黄",
            ["45303034303130383331464342333634", "45303034303130383331464338333242", "45303034303130383331464338463742", "45303034303130383331464339354142"]: "绿红粉橙",
            ["45303034303130383331464342333634", "45303034303130383331464338333242", "45303034303130383331464338463742", "45303034303130383331464338393338"]: "绿红粉蓝",
            
            
            ["45303034303130383331464337453842", "45303034303130383331464339414439", "45303034303130383331464338333242", "45303034303130383331464342333634"]: "白黄红绿",
            ["45303034303130383331464337453842", "45303034303130383331464339354142", "45303034303130383331464339414439", "45303034303130383331464338393338"]: "白橙黄蓝",
            ["45303034303130383331464337453842", "45303034303130383331464338463742", "45303034303130383331464338333242", "45303034303130383331464342333634"]: "白粉红绿",
            ["45303034303130383331464337453842", "45303034303130383331464338333242", "45303034303130383331464338463742", "45303034303130383331464339414439"]: "白红粉黄",
            ["45303034303130383331464337453842", "45303034303130383331464338333242", "45303034303130383331464339414439", "45303034303130383331464339354142"]: "白红黄橙",
            ["45303034303130383331464337453842", "45303034303130383331464338333242", "45303034303130383331464339414439", "45303034303130383331464338393338"]: "白红黄蓝",
            ["45303034303130383331464338333242", "45303034303130383331464342333634", "45303034303130383331464339414439", "45303034303130383331464339354142"]: "红绿黄橙",


        ]

        let receivedDataSet = Set(receivedDataList)

        for (condition, imageName) in conditionCombinations {
            if receivedDataSet == condition {
                if let image = UIImage(named: imageName) {
                    savedPhotos.append(image)
                }
                receivedDataList = [] // 清空已接收的数据列表
                break
            }
        }
    }



    func handleReceivedData(_ data: Data) {
        let hexString = data.hexEncodedString()
        receivedDataList.append(hexString)
        checkAndUpdateSavedPhotos()
    }

    func displayImage(imageName: String) {
        if let image = UIImage(named: imageName) {
            savedPhotos.append(image)
        } else {
            print("Error: Image not found.")
        }
    }

    func sendData(_ data: Data) {
        if let peripheral = connectedPeripheral, let targetCharacteristic = targetCharacteristic {
            if targetCharacteristic.properties.contains(.write) {
                peripheral.writeValue(data, for: targetCharacteristic, type: .withResponse)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("写入特征值失败：", error.localizedDescription)
        } else {
            print("写入特征值成功")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("更新通知状态失败：", error.localizedDescription)
        } else {
            print("更新通知状态成功")
        }
    }

    func disconnectFromDevice() {
        if let centralManager = centralManager, let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("断开连接失败：", error.localizedDescription)
        } else {
            print("已断开与蓝牙设备的连接")
            connectedPeripheral = nil
        }
    }
    
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

                 
                        
                        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
