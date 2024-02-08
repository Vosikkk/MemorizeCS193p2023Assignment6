//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI

struct ThemeChooser: View {
    
    @ObservedObject var store: ThemeStore
    
    private let font = Font.system(size: 25)
    
    var body: some View {
        List(store.themes) { theme in
            VStack(alignment: .leading, spacing: 5) {
                Text(theme.name)
                    .foregroundStyle(store.getColor(for: theme))
                Text(theme.emojis).lineLimit(1)
            }
            .font(font)
        }
    }
}




#Preview {
    ThemeChooser(store: ThemeStore(named: "Preview"))
       
}
