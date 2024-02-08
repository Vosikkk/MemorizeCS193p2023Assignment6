//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI

struct ThemeChooser: View {
    
    @ObservedObject var store: ThemeStore
    
    private let font = Font.system(size: 20)
    
    var body: some View {
        List(store.themes) { theme in
             row(theme)
            .font(font)
            .shadow(color: .blue,
                    radius: Constants.radius,
                    x: Constants.positionX,
                    y: Constants.positionY)
        }
    }
    
    private func row(_ theme: Theme) -> some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
                Text(theme.name)
            HStack {
                Text("Color:")
                Text("\(theme.uiColor.name)")
                    .foregroundStyle(theme.uiColor)
            }
            HStack {
                Text("Cards:")
                Text(theme.pairs, format: .number)
            }
            Text(theme.emojis).lineLimit(1)
        }
    }
    
    private struct Constants {
        static let radius: CGFloat = 0.3
        static let positionX: CGFloat = 0.2
        static let positionY: CGFloat = 0.2
        static let spacing: CGFloat = 5
    }
}




#Preview {
    ThemeChooser(store: ThemeStore(named: "Preview"))
       
}
