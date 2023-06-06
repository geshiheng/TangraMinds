//
//  FreeformArtistryView.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/1/23.
//

import SwiftUI

struct FreeformArtistryView: View {
    @State private var showGalleryView = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Freeform Artistry")
                    .font(.largeTitle)
                    .padding()
                
                Text("Unleash your creativity with the Freeform Artistry mode. Without the constraints of any pre-determined shapes, this mode allows you to freely experiment and create any design you desire. Let your imagination run wild and use the pieces to construct your unique shapes. This is the perfect playground for your limitless imagination!")
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
                        showGalleryView = true
                    }) {
                        Text("Go")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showGalleryView) {
                        GalleryView()
                    }
                    .padding()
                }
            }
        }
    }
}

struct FreeformArtistryView_Previews: PreviewProvider {
    static var previews: some View {
        FreeformArtistryView()
    }
}

