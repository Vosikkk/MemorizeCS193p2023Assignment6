//
//  EmojiMemoryGame.swift
//  Assignment1Memorize
//
//  Created by Саша Восколович on 23.12.2023.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
   
    @Published private var game: MemoryGame<String>
    
    var cards: [MemoryGame<String>.Card] {
        return game.cards
    }
    
    var score: Int {
         game.score
    }
    
    var nameOfTheme: String {
         theme.name
    }
    var colorOfTheme: Color {
        theme.uiColor
    }
    
    private var theme: Theme
    
    
    init(theme: Theme) {
        self.theme = theme
        game = MemoryGame(pairsOfCards: max(theme.numberOfPairs, 2), cardContentFactory: {
            theme.emojis.map(String.init)[$0]
        })
    }
    
    
    func new() {
        game = MemoryGame(pairsOfCards: max(theme.numberOfPairs, 2), cardContentFactory: {
             theme.emojis.map(String.init)[$0]
        })
    }

   
    
    // MARK: - Intents
    
    
    func shuffle() {
        game.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }
}
