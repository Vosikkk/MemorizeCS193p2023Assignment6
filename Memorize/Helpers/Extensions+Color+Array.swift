//
//  Extensions+Color+Array.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI
import UIKit

extension Color {
    init(rgba: RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
    
    var name: String {
        UIColor(self).accessibilityName
            .split(separator: " ")
            .map { $0.prefix(1).capitalized + $0.dropFirst() }
            .joined(separator:" ")
    }
    
}

extension Array where Element: Identifiable {
        
    subscript(_ elementId: Element.ID) -> Element? {
        if let index = index(of: elementId) {
            return self[index]
        } else {
            return nil
        }
    }
    
    subscript(_ element: Element) -> Element {
        get {
            if let index = index(of: element.id) {
                return self[index]
            } else {
                return element // should probably throw error
            }
        }
        set {
            if let index = index(of: element.id) {
                self[index] = newValue
            }
        }
    }
    
    private func index(of elementId: Element.ID) -> Int? {
        firstIndex(where: { $0.id == elementId } )
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
