//
//  PhotoLibraryViewModel.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/7/23.
//

import Foundation
import SwiftUI

class PhotoLibraryViewModel: ObservableObject {
    @Published var photos: [UIImage] = []
    
    @Published var selectedPhoto: UIImage?

    private let databaseManager: DatabaseManager

    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
        loadPhotos()
    }

    func loadPhotos() {
        photos = databaseManager.retrievePhotos()
    }
}
