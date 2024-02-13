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
    @State private var games: [Theme.ID: EmojiMemoryGame] = [:]
    
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
                .listStyle(.inset)
                .animation(.snappy, value: showThemeEditor)
                
                .sheet(isPresented: $showThemeEditor) {
                    if let choosenTheme {
                        ThemeEditor(theme: $store.themes[choosenTheme])
                    }
                }
                .navigationDestination(for: Theme.ID.self) { themeId in
                    if let theme = store.themes[themeId] {
                        EmojiMemoryGameView(game: game(for: theme))
                    }
                }
                .onChange(of: choosenTheme) { _ , _ in
                        showThemeEditor = true
                }
                
                .onChange(of: store.themes) { oldValue, newValue in
                    updateGames(from: oldValue, to: newValue)
                }
                .navigationTitle("Memorize")
                .toolbar {
                   toolBarView()
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
    
    private func game(for theme: Theme) -> EmojiMemoryGame {
        if games[theme.id] == nil {
            let game = EmojiMemoryGame(theme: theme)
            games[theme.id] = game
            return game
        }
        return games[theme.id]!
    }
    
    private func color(for theme: Theme) -> some View {
        HStack {
            Text("Color:")
            Text("\(theme.uiColor.name)")
                .foregroundStyle(theme.uiColor.gradient)
        }
    }
    
    private func cards(for theme: Theme) -> some View {
        HStack {
            Text("Cards:")
            Text(theme.cards, format: .number)
        }
    }
    
    @ViewBuilder func toolBarView() -> some View {
        HStack(spacing: 10) {
            Text("Create Game")
                .font(.title3)
                .fontWeight(.semibold)
        }
        Button {
            store.insert(name: "", emojis: "")
            choosenTheme = store.themes.first
        } label: {
            Image(systemName: "plus")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(.blue.gradient, in: .circle)
                .contentShape(.circle)
        }
    }

    private func updateGames(from oldThemes: [Theme], to newThemes: [Theme]) {
        for index in 0..<newThemes.count {
            if index < oldThemes.count, newThemes[index] != oldThemes[index],
               games.keys.contains(newThemes[index].id) {
                games[newThemes[index].id] = EmojiMemoryGame(theme: newThemes[index])
            }
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
