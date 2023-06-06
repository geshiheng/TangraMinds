//
//  String+Extensions.swift
//  TangraMinds
//
//  Created by Shiheng Ge on 6/4/23.
//

import Foundation
extension String {
    func hexData() -> Data? {
        let len = self.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = self.index(self.startIndex, offsetBy: i*2)
            let k = self.index(j, offsetBy: 2)
            let bytes = self[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            }
        }
        return data
    }
}
