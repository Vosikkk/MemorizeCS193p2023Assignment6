//
//  SplitThemeChooser.swift
//  Memorize
//
//  Created by Саша Восколович on 21.02.2024.
//

import SwiftUI

struct SplitThemeChooser: View {
    
    @EnvironmentObject var store: ThemeStore
    @State private var selectedTheme: Theme?
    
    @State private var showThemeEditor: Bool = false
    
    @State private var games: [Theme.ID: (game: EmojiMemoryGame, cadsOnTheTable: Bool)] = [:]
    
    
    var body: some View {
        NavigationSplitView {
            List(store.themes, selection: $selectedTheme) { theme in
                 ThemeView(theme: theme)
                    .tag(theme)
            }
            .toolbar {
                Button(action: {
                    showThemeEditor = true
                }, label: {
                    Image(systemName: "pencil")
                })
            }
        } detail: {
            if let selectedTheme {
                let gameInfo = getGame(for: selectedTheme)
                EmojiMemoryGameView(game: gameInfo.game, hasBeenOpened: gameInfo.cadsOnTheTable) { cardsOnTheTable in
                    games[selectedTheme.id]?.cadsOnTheTable = cardsOnTheTable
                }
            } else {
                Text("Choose Theme")
            }
        }
        
        .sheet(isPresented: $showThemeEditor) {
            NavigationStack {
                EditableThemesList(store: store)
            }
        }
        .onChange(of: store.themes) { oldValue, newValue in
            updateGames(from: oldValue, to: newValue)
        }
    }
    
    
    private func getGame(for theme: Theme) -> (game: EmojiMemoryGame, cadsOnTheTable: Bool) {
        if games[theme.id] == nil {
            let game = (EmojiMemoryGame(theme: theme), cadsOnTheTable: false)
            games[theme.id] = game
            return game
        }
        return games[theme.id]!
    }
    
    
    private func updateGames(from oldThemes: [Theme], to newThemes: [Theme]) {
        for index in 0..<newThemes.count {
            if index < oldThemes.count, newThemes[index] != oldThemes[index],
               games.keys.contains(newThemes[index].id) {
                /// We made some changes on the theme, so cards will go from the deck as a new game
                games[newThemes[index].id] = (game: EmojiMemoryGame(theme: newThemes[index]), cadsOnTheTable: false)
            }
        }
    }
}

#Preview {
    SplitThemeChooser()
        .environmentObject(ThemeStore(named: "Preview"))
}

struct ThemeView: View {
    
    var theme: Theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(theme.name)
                .fontWeight(.bold)
            color(for: theme)
            cards(for: theme)
            Text(theme.emojis).lineLimit(1)
        }
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
    
    private struct Constants {
        static let radius: CGFloat = 0.3
        static let positionX: CGFloat = 0.2
        static let positionY: CGFloat = 0.2
        static let spacing: CGFloat = 5
        static let spacing2: CGFloat = 2
        static let spacing3: CGFloat = 10
        
        struct Size {
            static let width: CGFloat = 30
            static let height: CGFloat = 30
        }
    }
}
