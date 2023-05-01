//
//  DatabaseManager.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/7/23.
//

import Foundation
import SQLite
import SwiftUI

class DatabaseManager: ObservableObject {
    private let db: Connection
    private let photos = Table("photos")
    private let idColumn = Expression<Int64>("id")
    private let imageColumn = Expression<Blob>("image")

    init() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = documentDirectory.appendingPathComponent("photoDatabase.sqlite3")

        do {
            db = try Connection(dbPath.path)
            try createTableIfNeeded()
        } catch {
            print("Error initializing the database: \(error.localizedDescription)")
            fatalError("Unable to initialize the database.")
        }
    }

    private func createTableIfNeeded() throws {
        try db.run(photos.create(ifNotExists: true) { table in
            table.column(idColumn, primaryKey: .autoincrement)
            table.column(imageColumn)
        })
    }

    func insertPhoto(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let bytes = [UInt8](imageData)
            let blob = Blob(bytes: bytes)
            let insert = photos.insert(imageColumn <- blob)
            do {
                try db.run(insert)
            } catch {
                print("Error inserting the photo: \(error.localizedDescription)")
            }
        }
    }

    func retrievePhotos() -> [UIImage] {
        var images: [UIImage] = []
        do {
            for row in try db.prepare(photos) {
                if let imageData: Blob = try? row.get(imageColumn) {
                    let foundationData = Data(bytes: imageData.bytes, count: imageData.bytes.count)
                    if let image = UIImage(data: foundationData) {
                        images.append(image)
                    }
                }
            }
        } catch {
            print("Error retrieving photos: \(error.localizedDescription)")
        }
        return images
    }
    
    func deleteAllPhotos() {
        do {
            try db.run(photos.delete())
        } catch {
            print("Error deleting all photos: \(error.localizedDescription)")
        }
    }

}
