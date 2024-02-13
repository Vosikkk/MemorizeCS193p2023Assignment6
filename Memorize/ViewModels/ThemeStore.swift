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
                objectWillChange.send()
            }
        }
    }
    
    
    init(named name: String) {
        self.name = name
       // UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        if themes.isEmpty {
            themes = Theme.builtins
            if themes.isEmpty {
                themes = [Theme(name: "Warning", emojis: "⚠️", color: RGBA(color: Color.blue), numberOfPairs: 3)]
            }
        }
    }
    
    func insert(name: String, emojis: String, color: Color = Color.red, numberOfPairs: Int = 2) {
        let newTheme = Theme(name: name, emojis: emojis, color: RGBA(color: color), numberOfPairs: numberOfPairs)
        themes.insert(newTheme, at: 0)
    }
}


extension RGBA {
    
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension Theme {
    
    var uiColor: Color {
        Color(rgba: color)
    }
    
    func rGBA(from color: Color) -> RGBA {
        RGBA(color: color)
    }
    
    var cards: Int {
        numberOfPairs * 2
    }
}
