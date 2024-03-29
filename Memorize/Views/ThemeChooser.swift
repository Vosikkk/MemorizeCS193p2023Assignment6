//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI

struct ThemeChooser: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var store: ThemeStore
    @State private var showThemeEditor: Bool = false
    @State private var choosenTheme: Theme?
    @State private var games: [Theme.ID: (game: EmojiMemoryGame, cadsOnTheTable: Bool)] = [:]
    
    private let font = Font.system(size: 20)
    
    
    // MARK: - Views 
    
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
                
                .sheet(isPresented: $showThemeEditor,
                       onDismiss: {
                    /// When we want reopen the same theme
                    choosenTheme = nil
                    
                    if let theme = store.themes.first, theme.emjisCount < 2 {
                        store.remove(theme)
                    }
                }, content: {
                    if let choosenTheme {
                        ThemeEditor($store.themes[choosenTheme])
                    }
                })
                .navigationDestination(for: Theme.ID.self) { themeId in
                    if let theme = store.themes[themeId] {
                        let gameInfo = getGame(for: theme)
                        EmojiMemoryGameView(game: gameInfo.game, hasBeenOpened: gameInfo.cadsOnTheTable) { cadsAlreadyOnTheTable in
                            /// It helps us to understand which games already have cards on the table and which don't
                            games[theme.id]?.cadsOnTheTable = cadsAlreadyOnTheTable
                        }
                    }
                }
            
                .onChange(of: choosenTheme) { _ , newValue in
                    showThemeEditor = newValue != nil
                }
                .onChange(of: store.themes) { oldValue, newValue in
                    updateGames(from: oldValue, to: newValue)
                }
                /// Showing Trasnlucent Toolbar
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
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
    
    private func getGame(for theme: Theme) -> (game: EmojiMemoryGame, cadsOnTheTable: Bool) {
        if games[theme.id] == nil {
            let game = (EmojiMemoryGame(theme: theme), cadsOnTheTable: false)
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
        
        HStack(spacing: Constants.spacing3) {
            Text("Memorize")
                .font(.title.bold())
                .padding()
            Spacer()
            HStack(spacing: Constants.spacing2) {
                Text("Create")
                    .font(.caption2)
                    .fontWeight(.semibold)
                Button {
                    store.insert(name: "", emojis: "")
                    choosenTheme = store.themes.first
                } label: {
                    Image(systemName: "plus")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: Constants.Size.width, height: Constants.Size.height)
                        .background(.blue.gradient, in: .circle)
                        .contentShape(.circle)
                }
            }
        }
    }

    // MARK: - Helpers
    
    /// When we change theme we want  our games to see this change and set it
    private func updateGames(from oldThemes: [Theme], to newThemes: [Theme]) {
        for index in 0..<newThemes.count {
            if index < oldThemes.count, newThemes[index] != oldThemes[index],
               games.keys.contains(newThemes[index].id) {
                /// We made some changes on the theme, so cards will go from the deck as a new game
                games[newThemes[index].id] = (game: EmojiMemoryGame(theme: newThemes[index]), cadsOnTheTable: false)
            }
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

#Preview {
    ThemeChooser()
        .environmentObject(ThemeStore(named: "Preview"))
}
