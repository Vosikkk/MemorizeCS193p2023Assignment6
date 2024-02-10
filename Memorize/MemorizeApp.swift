//
//  Assignment1MemorizeApp.swift
//  Assignment1Memorize
//
//  Created by Саша Восколович on 18.12.2023.
//

import SwiftUI

@main
struct Assignment1MemorizeApp: App {
    
   // @StateObject var game = EmojiMemoryGame()
    @StateObject var themesStore = ThemeStore(named: "Main")
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
           // EmojiMemoryGameView(viewModel: game)
                .environmentObject(themesStore)
        }
    }
}
