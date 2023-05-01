//
//  DatabaseManagerWrapper.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/7/23.
//

import Foundation

class DatabaseManagerWrapper: ObservableObject {
    static let shared = DatabaseManagerWrapper()

    var databaseManager: DatabaseManager? = DatabaseManager()

    private init() {}
}
