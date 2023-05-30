//
//  FunctionView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/1/23.
//

import SwiftUI

struct FunctionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                // New leaner button action
            }) {
                Text("New Learner")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Smart Builder button action
            }) {
                Text("Smart Builder")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Freeform Artistry button action
            }) {
                Text("Freeform Artistry")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Puzzle Master button action
            }) {
                Text("Puzzle Master")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Masterpiece Showcase button action
            }) {
                Text("Masterpiece Showcase")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct FunctionView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionView()
    }
}
