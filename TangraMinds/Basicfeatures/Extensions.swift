//
//  Extensions.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 5/6/23.
//

import Foundation
extension Data {
    init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }
}

extension Array where Element == UInt8 {
    init(hex: String) {
        self = stride(from: 0, to: hex.count, by: 2).compactMap {
            let start = hex.index(hex.startIndex, offsetBy: $0)
            let end = hex.index(start, offsetBy: 2, limitedBy: hex.endIndex) ?? hex.endIndex
            return UInt8(hex[start..<end], radix: 16)
        }
    }
}
