//
//  PuzzleMasterView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/1/23.
//

import SwiftUI

struct PuzzleMasterView: View {
    @State private var isSheetPresented = false // 添加这个状态来跟踪何时显示 sheet

    var body: some View {
        NavigationView {
            VStack {
                Text("Puzzle Master")
                    .font(.largeTitle)
                    .padding()

                Text("This mode offers outlines of different shapes, and your task is to fit the tangram pieces within these outlines accurately. It's a fun and engaging way to improve your problem-solving skills and spatial awareness. Scan your work with the integrated camera once you've finished, and the app will confirm if the shape matches the provided outline. Are you ready to become the ultimate Puzzle Master?")
                    .font(.title)
                    .padding()

                Spacer()

                HStack {
                    Button(action: {
                        // Back button action
                        // 这里可以添加Back按钮的操作代码
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
                        self.isSheetPresented.toggle() // 在按钮点击时切换状态
                    }) {
                        Text("Go")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $isSheetPresented) {
                        PuzzlePickView() // 当 isSheetPresented 为 true 时，显示这个视图
                    }
                }
            }
        }
    }
}

struct PuzzleMasterView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleMasterView()
    }
}
