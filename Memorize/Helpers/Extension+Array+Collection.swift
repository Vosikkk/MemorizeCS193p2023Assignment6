//
//  Extension+Array+Collection.swift
//  Memorize
//
//  Created by Саша Восколович on 28.03.2024.
//

import Foundation


extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
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
    
    mutating func remove(_ element: Element) {
        if let index = index(of: element.id) {
                remove(at: index)
            }
        }
    
}

