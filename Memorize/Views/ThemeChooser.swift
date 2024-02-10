//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI

struct ThemeChooser: View {
    
    @EnvironmentObject var store: ThemeStore
    @State private var showThemeEditor: Bool = false
    @State private var choosenTheme: Theme?
   
    
    private let font = Font.system(size: 20)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(value: theme.id) {
                        row(of: theme)
                    }
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .sheet(isPresented: $showThemeEditor) {
                if let choosenTheme {
                    ThemeEditor(theme: $store.themes[choosenTheme])
                }
            }
            .navigationDestination(for: Theme.ID.self) { themeId in
                if let theme = store.themes[themeId] {
                    EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                }
            }
            .onChange(of: choosenTheme) { _ , _ in
                 showThemeEditor = true
            }
            .listStyle(.inset)
            .navigationTitle("Memorize")
            .toolbar {
                Button {
                    store.insert(name: "", emojis: "")
                    choosenTheme = store.themes.first
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private func row(of theme: Theme) -> some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
                Text(theme.name)
                .fontWeight(.bold)
            color(for: theme)
            cards(for: theme)
            Text(theme.emojis).lineLimit(1)
        }
        .onTapGesture {
            choosenTheme = theme
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
            Text(theme.cards, format: .number)
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
    ThemeChooser()
        .environmentObject(ThemeStore(named: "Preview"))
}
