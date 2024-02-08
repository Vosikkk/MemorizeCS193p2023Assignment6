//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Саша Восколович on 08.02.2024.
//

import SwiftUI

struct ThemeEditor: View {
    
    @Binding var theme: Theme
    @State var emojiToAdd: String = ""
    @State var selectedColor: Color = .red
    
    private let emojiFont = Font.system(size: 40)
    
    
    var body: some View {
        Form {
            nameTextField
            emojisTextFiled
            colorPicker
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
        } header: {
            Text("Name")
        }
    }
    
    private var emojisTextFiled: some View {
        Section {
            TextField("Add Emojis Here", text: $emojiToAdd)
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
