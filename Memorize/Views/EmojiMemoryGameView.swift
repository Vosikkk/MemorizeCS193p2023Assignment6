//
//  ContentView.swift
//  Assignment1Memorize
//
//  Created by Саша Восколович on 18.12.2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text("\(game.nameOfTheme)")
                Spacer()
                Text("Score: \(game.score)")
            }
            .font(.title)
            .fontWeight(.semibold)
            
            ScrollView(showsIndicators: false) {
                cards
            }
          
//            Button("New Game") {
//                viewModel.new()
//            }
            //.font(.title)
        }
        .toolbarTitleDisplayMode(.inline)
        .foregroundStyle(game.colorOfTheme)
        .padding(.horizontal, 10)
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(game.cards.indices, id: \.self) { index in
                CardView(card: game.cards[index], model: game)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }
        .foregroundStyle(game.colorOfTheme)
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

//
//#Preview {
//    EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: ))
//}
