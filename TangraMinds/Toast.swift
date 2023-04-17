//
//  ToastView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 4/16/23.
//


import SwiftUI

struct Toast: View {
    let message: String
    @State private var isPresented = false

    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .bold()
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .scaleEffect(isPresented ? 1 : 0.1)
                .opacity(isPresented ? 1 : 0)
                .animation(.easeInOut, value: isPresented)
        }
        .padding(.top, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isPresented = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
        }
    }
}
