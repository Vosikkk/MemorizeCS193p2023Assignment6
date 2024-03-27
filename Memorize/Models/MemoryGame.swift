//
//  MemoryGame.swift
//  Assignment1Memorize
//
//  Created by Саша Восколович on 23.12.2023.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    
    private var matchedIndexes: Int {
        return cards.indices.filter { cards[$0].isFaceUp && cards[$0].isMatched }.count
    }
    
    private(set) var score: Int = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue }
        }
    }
    
    init(pairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, pairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
        shuffle()
    }
    
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), !card.isFaceUp, !card.isMatched {
            if let potentialMatchedIndex = indexOfOneAndOnlyFaceUpCard {
                if card.content == cards[potentialMatchedIndex].content {
                    cards[potentialMatchedIndex].isMatched = true
                    cards[chosenIndex].isMatched = true
                    score += 2 + cards[chosenIndex].bonus + cards[potentialMatchedIndex].bonus
                } else {
                    if cards[chosenIndex].hasAlreadyBeenSeen || cards[potentialMatchedIndex].hasAlreadyBeenSeen {
                        score -= 1 // dismatch
                    }
                }
                
                // open second card
                cards[chosenIndex].isFaceUp.toggle()
                
            } else {
                indexOfOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    
    struct Card: Identifiable, Equatable, CustomStringConvertible {
        
        var id = UUID()
        
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    hasAlreadyBeenSeen = true
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        let content: CardContent
        var hasAlreadyBeenSeen: Bool = false
        
        
        
        // MARK: - Bonus Time
        
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusParcentRemaining > 0 && lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusParcentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusParcentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime) / bonusTimeLimit : 0
        }
        
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        var description: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}

