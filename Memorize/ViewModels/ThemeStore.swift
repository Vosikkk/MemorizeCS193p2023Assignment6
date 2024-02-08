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
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
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
    
    
    private func convert(_ color: Color) -> RGBA {
        RGBA(color: color)
    }
    
    private func convert(_ rgba: RGBA) -> Color {
        Color(rgba: rgba)
    }
    
    
    private func append(_ theme: Theme) {
        if let index = themes.getIndex(of: theme) {
            if themes.count == 1 {
                themes = [theme]
            } else {
                themes.remove(at: index)
                themes.append(theme)
            }
        } else {
            themes.append(theme)
        }
    }
    
    func append(name: String, emojis: String, color: Color) {
        append(Theme(name: name, emojis: emojis, color: convert(color)))
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
}