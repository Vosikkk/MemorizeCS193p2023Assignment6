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
        return game.score
    }
    
    var nameOfTheme: String {
        return currentTheme.name
    }
    
    private var currentTheme: Theme
    
    
//    init() {
//
//        game = MemoryGame(pairsOfCards: min(randomTheme.emojis.count, randomTheme.numbersOfPairs), cardContentFactory: {
//            return randomTheme.emojis[$0]
//        })
//        currentTheme = randomTheme
//    }
//    
//    
//    func new() {
//        let randomTheme = themes.randomElement() ?? themes[0]
//        game = MemoryGame(pairsOfCards: min(randomTheme.emojis.count, randomTheme.numbersOfPairs), cardContentFactory: {
//            return randomTheme.emojis[$0]
//        })
//        currentTheme = randomTheme
//    }

   
    
    // MARK: - Intents
    
    
    func shuffle() {
        game.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }

    
}
