//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Саша Восколович on 08.02.2024.
//

import SwiftUI

struct ThemeEditor: View {
    
    @Binding var theme: Theme
    @State private var emojiToAdd: String = ""
    @State private var selectedColor: Color = .red
    @FocusState private var focuced: Focused?
    
    private let emojiFont = Font.system(size: 30)

    
    enum Focused {
        case name
        case addEmojis
    }
    
    var body: some View {
        Form {
            nameTextField
            emojisTextFiled
            colorPicker
            numberOfCards
        }
        .onAppear {
            if theme.name.isEmpty {
                focuced = .name
            } else {
                focuced = .addEmojis
            }
        }
    }
    
    private var colorPicker: some View {
        Section {
            ColorPicker("Current Color", selection: $selectedColor)
                .onChange(of: selectedColor) { oldValue, newValue in
                    theme.color = theme.rGBA(from: newValue)
                }
                .foregroundStyle(theme.uiColor)
        } header: {
            Text("Color")
        }
    }
    
    private var nameTextField: some View {
        Section {
            TextField("Name", text: $theme.name)
                .focused($focuced, equals: .name)
        } header: {
            Text("Name")
        }
    }
    
    private var emojisTextFiled: some View {
        Section {
            TextField("Add Emojis Here", text: $emojiToAdd)
                .focused($focuced, equals: .addEmojis)
                .font(emojiFont)
                .onChange(of: emojiToAdd) { oldValue, newValue in
                    theme.emojis = (newValue + theme.emojis)
                        .filter { $0.isEmoji }
                        .uniqued
                }
            removeEmojis
        } header: {
             Text("Emojis")
        }
    }
    
    private var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to Remove Emojis").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                  ForEach(theme.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .opacity(isInGame(emoji) ? 1 : 0.4)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.remove(emoji.first!)
                                emojiToAdd.remove(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
    
    private var numberOfCards: some View {
        Section {
            Stepper("Pairs In Game: \(theme.numberOfPairs)", value: $theme.numberOfPairs, in: 2...theme.emojis.count)
                .onChange(of: theme.numberOfPairs) { oldValue, newValue in
                    theme.numberOfPairs = max(2, min(newValue, theme.emojis.count))
                }
        } header: {
            Text("Max available quantity: \(theme.pairs)")
        }
    }
    
    private func isInGame(_ emoji: String) -> Bool {
        theme.emojis.prefix(theme.numberOfPairs).contains(emoji)
    }
}

struct Preview: View {
    @State private var theme = ThemeStore(named: "Preview").themes.first!
    
    var body: some View {
        ThemeEditor(theme: $theme)
    }
}

#Preview {
   Preview()
}
