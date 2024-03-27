//
//  Extension+String+Character.swift
//  Memorize
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation

extension String {
    
    var uniqued: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
    
    mutating func remove(_ ch: Character) {
        removeAll(where: { $0 == ch })
    }
    
    mutating func add(_ ch: Character) {
        insert(ch, at: startIndex)
    }
}

extension Character {
    
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}
