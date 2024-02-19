//
//  CardView.swift
//  Memorize
//
//  Created by Саша Восколович on 19.02.2024.
//

import SwiftUI

typealias Card = MemoryGame<String>.Card

struct CardView: View {
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            if card.isFaceUp || !card.isMatched {
                Pie(endAngle: .degrees(card.bonusParcentRemaining * Constants.Animation.degrees))
                    .opacity(Constants.Pie.opacity)
                    .overlay(cardContent.padding(Constants.Pie.inset))
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale)
            } else {
                Color.clear
            }
        }
    }
    
    var cardContent: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .aspectRatio(Constants.aspectRatio, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? Constants.Animation.degrees : 0))
            .animation(.spin(duration: Constants.Animation.duration), value: card.isMatched)
    }
    
    
    private struct Constants {
        static let inset: CGFloat = 5
        static let aspectRatio: CGFloat = 1
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        
        struct Pie {
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
        
        struct Animation {
            static let degrees: CGFloat = 360
            static let duration: CGFloat = 1
        }
    }
}

#Preview {
    HStack {
        CardView(Card(isFaceUp: true, content: "X"))
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}
