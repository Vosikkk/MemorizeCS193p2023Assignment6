//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI

struct ThemeChooser: View {
    
    @ObservedObject var store: ThemeStore
    @State private var showThemeEditor: Bool = false
    @State private var themeId: Theme.ID?
    
    private let font = Font.system(size: 20)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.themes) { theme in
                    row(of: theme)
                        .gesture(tap(on: theme))
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .sheet(isPresented: $showThemeEditor) {
                if let index = store.themes.firstIndex(where: { $0.id == themeId }) {
                    
                    ThemeEditor(theme: $store.themes[index])
                }
            }
//            .navigationDestination(for: Theme.ID.self) { themeId in
//                if let index = store.themes.firstIndex(where: { $0.id == themeId }) {
//                    ThemeEditor(theme: $store.themes[index])
//                }
//            }
            .listStyle(.inset)
            .navigationTitle("Memorize")
        }
    }
    
    private func row(of theme: Theme) -> some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
                Text(theme.name)
                .fontWeight(.bold)
            color(for: theme)
            cards(for: theme)
            Text(theme.emojis).lineLimit(1)
        }
        .font(font)
        .shadow(color: .blue,
                radius: Constants.radius,
                x: Constants.positionX,
                y: Constants.positionY)
    }
    
    private func color(for theme: Theme) -> some View {
        HStack {
            Text("Color:")
            Text("\(theme.uiColor.name)")
                .foregroundStyle(theme.uiColor)
        }
    }
    
    private func cards(for theme: Theme) -> some View {
        HStack {
            Text("Cards:")
            Text(theme.pairs, format: .number)
        }
    }
    
    private func tap(on theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                self.themeId = theme.id
                showThemeEditor = true
            }
    }
    
    private struct Constants {
        static let radius: CGFloat = 0.3
        static let positionX: CGFloat = 0.2
        static let positionY: CGFloat = 0.2
        static let spacing: CGFloat = 5
    }
}

#Preview {
    ThemeChooser(store: ThemeStore(named: "Preview"))
       
}
