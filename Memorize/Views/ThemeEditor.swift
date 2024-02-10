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
    private let removedEmojiFont = Font.system(size: 20)

    
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
            removedEmojis
        }
        .scrollIndicators(.hidden)
        .onAppear {
            if theme.name.isEmpty {
                focuced = .name
            } else {
                focuced = .addEmojis
            }
            selectedColor = theme.uiColor
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
                                theme.removedEmojis.add(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
    
    
    private var removedEmojis: some View {
        Section { VStack(alignment: .trailing) {
            Text("Tap To Return Emojis").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 20))]) {
                ForEach(theme.removedEmojis.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.removedEmojis.remove(emoji.first!)
                                theme.emojis.add(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(removedEmojiFont)
        } header: {
            Text("Shows Removed Emojis")
        }
    }
    
    private var isEmptyRemoved: Bool {
        theme.removedEmojis.isEmpty
    }
    
    private var numberOfCards: some View {
        Section {
            Stepper("Pairs In Game: \(theme.numberOfPairs)", value: $theme.numberOfPairs, in: theme.emojis.count > 0 ? 2...theme.emojis.count : 2...2)
                .onChange(of: theme.numberOfPairs) { oldValue, newValue in
                    theme.numberOfPairs = max(2, min(newValue, theme.emojis.count))
                }
        } header: {
            Text("Max available quantity: \(theme.emojis.count)")
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
