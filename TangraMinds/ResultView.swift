//
//  ResultView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 4/16/23.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    let requiredData: Set<String> = [
        "3034413945454231373030303030",
        "3034414245454231373030303030",
        "3034413845454231373030303030",
        "3034413745454231373030303030"
    ]

    var shouldShowImages: Bool {
        Set(bluetoothManager.receivedData).intersection(requiredData).count == requiredData.count
    }

    var body: some View {
        if shouldShowImages {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 20) {
                    Image("fish")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)

                    Image("ferry")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)

                    Image("hill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)

                    Image("tree")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                .padding()
            }
        } else {
            Text("Please Select Some Tangras")
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(bluetoothManager: BluetoothManager())
    }
}

