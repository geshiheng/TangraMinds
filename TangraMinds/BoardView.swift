// BoardView.swift
import SwiftUI

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var isResultViewPresented = false

    let imageMapping: [String: String] = [
        "3034413745454231373030303030": "fish",
        "3034413845454231373030303030": "ferry",
        "3034414245454231373030303030": "hill",
        "3034413945454231373030303030": "tree",
        "3034414345454231373030303030": "image5",
        "3034414445454231373030303030": "image6",
        "3034414545454231373030303030": "image7"
    ]

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(bluetoothManager.receivedData, id: \.self) { data in
                        if let imageName = imageMapping[data] {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
            }

            Button(action: {
                isResultViewPresented = true
            }) {
                Text("Done")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(bluetoothManager.receivedData.count <= 1)
            .sheet(isPresented: $isResultViewPresented) {
                ResultView(bluetoothManager: bluetoothManager)
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(bluetoothManager: BluetoothManager())
    }
}
