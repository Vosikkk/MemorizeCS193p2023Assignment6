//
//  ContentView.swift
//  Memorize
//
//  Created by Саша Восколович on 18.12.2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var dealt: Set<Card.ID> = []
    
    @State private var lastScoreChange = (0, cousedByCardId: UUID())
    
    @State var hasBeenOpened: Bool
    
    var cardsOnTheTable: (Bool) -> Void?
    
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            HStack {
                nameOfTheme
                Spacer()
                score
            }
            .font(.title)
            .fontWeight(.semibold)
            
            cards
            
            HStack {
                newGameButton
                Spacer()
                deck
            }
        }
        .onAppear {
            if hasBeenOpened {
                /// Cards will be on the table immediately
                addToDealt()
            }
        }
        .onDisappear {
            cardsOnTheTable(hasBeenOpened)
        }
        .toolbarTitleDisplayMode(.inline)
        .foregroundStyle(game.colorOfTheme.gradient)
        .padding(.horizontal, Constants.inset)
    }
    
    private var cards: some View {
        AspectVGrid(game.cards, aspectRatio: Constants.aspectRatio, content: { card in
            if isDealt(card) {
                view(for: card)
                    .padding(Constants.spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                
                // we want that numbers appear always in front
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        })
        .background {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(game.colorOfTheme.opacity(Constants.opacity))
        }
    }
    
    
    private var newGameButton: some View {
        Button {
            withAnimation {
                game.new()
            }
            deal()
        } label: {
            VStack(spacing: Constants.secondSpacing) {
                Text("New Game")
                    .font(.caption.bold())
                Image(systemName: "gamecontroller")
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(width: Constants.Size.buttonWidth, height: Constants.Size.buttonWidth)
                    .background(game.colorOfTheme.gradient, in: .rect(cornerRadius: Constants.buttonCornerRadius))
                    .contentShape(.rect)
            }
        }
    }
    
    private var nameOfTheme: some View {
        Text("\(game.nameOfTheme)")
            .fillText(game.colorOfTheme, radius: Constants.cornerRadius)
    }
    
    
    private var score: some View {
        Text("Score: \(game.score)")
            .animation(nil)
            .fillText(game.colorOfTheme, radius: Constants.cornerRadius)
    }
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                view(for: card)
            }
        }
        .frame(width: Constants.Size.width, height: Constants.Size.width / Constants.aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func view(for card: Card) -> some View {
        CardView(card)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    
    // MARK: - Helpers
    
    private func deal() {
        hasBeenOpened = true
        var delay: TimeInterval = 0
        
        for card in game.cards {
            withAnimation(.easeInOut(duration: Constants.Animation.duration).delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += Constants.Animation.delay
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChange = game.score
            game.choose(card)
            let scoreChange = game.score - scoreBeforeChange
            lastScoreChange = (scoreChange, card.id)
        }
    }
    
    private func addToDealt() {
        game.cards.forEach { dealt.insert($0.id) }
    }
    
    private var undealtCards: [Card] {
        game.cards.filter { !isDealt($0) }
    }
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private struct Constants {
        
        static let aspectRatio: CGFloat = 2/3
        static let spacing: CGFloat = 4
        static let buttonCornerRadius: CGFloat = 15
        static let inset: CGFloat = 10
        static let cornerRadius: CGFloat = 15
        static let opacity: CGFloat = 0.1
        static let secondSpacing: CGFloat = 3
        
        struct Size {
            static let width: CGFloat = 50
            static let buttonWidth: CGFloat = 50
            static let buttonHeight: CGFloat = 50
        }
        
        struct Animation {
            static let delay: TimeInterval = 0.15
            static let duration: CGFloat = 1
        }
    }
}

