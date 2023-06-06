// BoardView.swift
//import SwiftUI
//
//struct BoardView: View {
//    @ObservedObject var bluetoothManager: BluetoothManager
//
//    @State private var imageNames: [String] = []
//    @State private var showResultView = false
//
//    func sendStop() {
//        let data = Data(hex: "73746F70")
//        bluetoothManager.sendData(data)
//    }
//
//    func sendStart() {
//        let data = Data(hex: "7374617274")
//        bluetoothManager.sendData(data)
//    }
//
//    func sendComplete() {
//        let data = Data(hex: "636F6D706C65746564")
//        bluetoothManager.sendData(data)
//    }
//
//    var body: some View {
//        VStack {
//            Spacer()
//
//            ScrollView {
//                LazyVStack {
//                    ForEach(imageNames, id: \.self) { imageName in
//                        Image(imageName)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: UIScreen.main.bounds.height / 5)
//                            .padding()
//                    }
//                }
//            }
//
//            Spacer()
//
//            HStack {
//                Button(action: sendStart) {
//                    Text("Start")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//
//                NavigationLink(destination: ResultView(bluetoothManager: bluetoothManager), isActive: $showResultView) {
//                    Button(action: {
//                        sendStop()
//                        showResultView = true
//                    }) {
//                        Text("Stop")
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//                .padding()
//
//                Button(action: sendComplete) {
//                    Text("Completed")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//            }
//            .padding(.bottom)
//        }
//        .onReceive(bluetoothManager.$receivedData, perform: { data in
//            var imageName: String?
//
//            switch data {
//            case "45303034303130383331464342333634":
//                imageName = "绿色大三角"
//            case "45303034303130383331464338333242":
//                imageName = "红色大三角"
//            case "45303034303130383331464337453842":
//                imageName = "白色正方形"
//            case "45303034303130383331464338393338":
//                imageName = "蓝色四边形"
//            case "45303034303130383331464338463742":
//                imageName = "粉色中三角"
//            case "45303034303130383331464339354142":
//                imageName = "橙色小三角"
//            case "45303034303130383331464339414439":
//                imageName = "黄色小三角"
//            default:
//                break
//            }
//
//            if let imageName = imageName {
//                imageNames.append(imageName)
//            }
//        })
//    }
//}
//
//struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardView(bluetoothManager: BluetoothManager())
//    }
//}

import SwiftUI

struct BoardView: View {
    @StateObject var bluetoothManager: BluetoothManager

    @State private var imageNames: [String] = []
    @State private var showResultView = false

    func sendStop() {
        let data = Data(hex: "73746F70")
        bluetoothManager.sendData(data)
    }

    func sendStart() {
        let data = Data(hex: "7374617274")
        bluetoothManager.sendData(data)
    }

    func sendComplete() {
        let data = Data(hex: "636F6D706C65746564")
        bluetoothManager.sendData(data)
        print(Unmanaged.passUnretained(bluetoothManager).toOpaque())

    }

    var body: some View {
        VStack {
            Spacer()

            ScrollView {
                LazyVStack {
                    ForEach(imageNames, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: UIScreen.main.bounds.width / 5, maxHeight: UIScreen.main.bounds.height / 5)
                            .padding()
                    }
                }
            }

            Spacer()

            HStack {
                Button(action: sendStart) {
                    Text("Start")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: {
                    sendStop()
                    showResultView = true
                }) {
                    Text("Stop")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: sendComplete) {
                    Text("Completed")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding(.bottom)
        }
        .onReceive(bluetoothManager.$receivedData, perform: { data in
            // 打印接收到的数据
            print("Received data: \(data)")

            var imageName: String?

            switch data {
            case "45303034303130383331464342333634":
                imageName = "蓝色大三角"
            case "45303034303130383331464338383337":
                imageName = "橙色大三角"
            case "45303034303130383331464337453842":
                imageName = "绿色正方形"
            case "45303034303130383331464338393338":
                imageName = "黄色四边形"
            case "45303034303130383331464338463742":
                imageName = "粉色中三角"
            case "45303034303130383331464339354142":
                imageName = "白色小三角"
            case "45303034303130383331464342343933":
                imageName = "红色小三角"
                
            default:
                break
            }

            // 打印解析后的 imageName
            if let imageName = imageName {
                print("Parsed imageName: \(imageName)")
                imageNames.append(imageName)
                print("Image names: \(imageNames)")
            }
        })

        .sheet(isPresented: $showResultView) {
            ResultView(bluetoothManager: bluetoothManager)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(bluetoothManager: BluetoothManager())
    }
}
