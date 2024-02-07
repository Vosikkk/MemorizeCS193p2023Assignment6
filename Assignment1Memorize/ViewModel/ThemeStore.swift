//
//  ThemeStore.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//
import SwiftUI
import Foundation

extension UserDefaults {
    
    func themes(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            return decodedThemes
        } else {
            return []
        }
    }
    
    func set(_ themes: [Theme], forKey key: String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
    
}



class ThemeStore: ObservableObject, Identifiable {
    
    
    let name: String
    
    var id: String { name }
    
    private var userDefaultsKey: String {
        "ThemeStore " + name
    }
    
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
            }
        }
    }
    
    
    init(named name: String) {
        self.name = name
        if themes.isEmpty {
            themes = Theme.builtins
            if themes.isEmpty {
                themes = [Theme(name: "Warning", emojis: "⚠️", color: RGBA(color: Color.blue))]
            }
        }
    }
    
    func getColor(for theme: Theme) -> Color {
        if let index = themes.getIndex(of: theme) {
            return convert(themes[index].color)
        }
        return Color.white
    }
    
    func set(_ color: Color, for theme: Theme) {
        if let index = themes.getIndex(of: theme) {
            themes[index].color = convert(color)
        }
    }
    
    
    func convert(_ color: Color) -> RGBA {
        RGBA(color: color)
    }
    
    func convert(_ rgba: RGBA) -> Color {
        Color(rgba: rgba)
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
