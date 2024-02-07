//
//  ContentView.swift
//  Assignment1Memorize
//
//  Created by Саша Восколович on 18.12.2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.nameOfTheme)")
                    .font(.largeTitle)
                .foregroundStyle(.cyan)
                Spacer()
                Text("Score: \(viewModel.score)")
                    .font(.largeTitle)
                    .foregroundStyle(.cyan)
            }
            .padding()
            
            ScrollView {
                cards
            }
            Button("New Game") {
                viewModel.new()
            }
            .font(.title)
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(card: viewModel.cards[index], model: viewModel)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }
        .foregroundStyle(viewModel.colorOfTheme)
    }
}


struct CardView: View {
    
    let card: MemoryGame<String>.Card
    let model: EmojiMemoryGame
   
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base
                    .foregroundStyle(.white)
                base
                    .strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.opacity(card.isFaceUp ? 0 : 1)
        } 
        .onTapGesture {
            model.choose(card)
        }
    }
    
}


#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
