//
//  Extensions+Color+Array.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI


extension Color {
    init(rgba: RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension Array where Element: Identifiable {
    func getIndex(of element: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == element.id {
                return index
            }
        }
        return nil
    }
}

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
