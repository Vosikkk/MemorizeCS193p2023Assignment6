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
    @State private var showAlert: Bool = false
    @State private var isSaveButtonDisabled: Bool = false
   
    /// When cancel it won't affect on our Themes
    @State private var tempTheme: Theme
    
    
    private let emojiFont = Font.system(size: 30)
    private let removedEmojiFont = Font.system(size: 20)
    
    @Environment(\.dismiss) private var dismiss
    
    
    init(_ theme: Binding<Theme>) {
        _theme = theme
        /// Work with this :)
        _tempTheme = State(initialValue: theme.wrappedValue)
    }
    
    
    enum Focused {
        case name
        case addEmojis
    }
    
    var body: some View {
        VStack {
            HStack {
                saveButton
                Spacer()
                cancelButton
            }
            .padding()
            Form {
                nameTextField
                emojisTextFiled
                colorPicker
                numberOfCards
                removedEmojis
            }
        }
        .onAppear {
            if tempTheme.name.isEmpty {
                focuced = .name
            } else {
                focuced = .addEmojis
            }
            selectedColor = tempTheme.uiColor
        }
        .onChange(of: tempTheme.emojis) { _ , newValue in
            if newValue.count > 1 {
                isSaveButtonDisabled = false
            }
        }
        .alert("Please Add Some Emojis", isPresented: $showAlert) { }
        .interactiveDismissDisabled(true)
        .scrollIndicators(.hidden)
    }
    
    private var colorPicker: some View {
        Section {
            ColorPicker("Current Color", selection: $selectedColor)
                .onChange(of: selectedColor) { _ , newValue in
                    tempTheme.color = tempTheme.rGBA(from: newValue)
                }
                .foregroundStyle(tempTheme.uiColor)
        } header: {
            Text("Color")
        }
    }
    
    private var nameTextField: some View {
        Section {
            TextField("Name", text: $tempTheme.name)
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
                    tempTheme.emojis = (newValue + tempTheme.emojis)
                        .filter { $0.isEmoji }
                        .uniqued
                }
            removeEmojis
        } header: {
             Text("Emojis")
        }
    }
    
    
    private var saveButton: some View {
        Button(action: {
            if isCorrectEmojiCount {
                if tempTheme != theme {
                    theme = tempTheme
                }
                dismiss()
            } else {
                
                /// Shows alert only once, then disabled button while emojis less than 2
                showAlert = true
                isSaveButtonDisabled = true
            }
        }, label: {
            Image(systemName: "arrowshape.down.circle")
                .font(.title2)
                .frame(width: Constants.Size.width, height: Constants.Size.height)
                .foregroundStyle(.white)
                .background(.blue.gradient, in: .circle)
                .contentShape(.circle)
                .opacity(isSaveButtonDisabled ? 0.4 : 1)
        })
        .disabled(isSaveButtonDisabled)
    }
    
    private var cancelButton: some View {
        Button(action: {
            dismiss()
        }, label: {
           Image(systemName: "xmark.circle")
                .frame(width: Constants.Size.width, height: Constants.Size.height)
                .foregroundStyle(.white)
                .background(.red.gradient, in: .circle)
                .contentShape(.circle)
        })
    }
    
    private var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to Remove Emojis").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                  ForEach(tempTheme.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .opacity(isInGame(emoji) ? 1 : 0.4)
                        .onTapGesture {
                            withAnimation {
                                tempTheme.emojis.remove(emoji.first!)
                                emojiToAdd.remove(emoji.first!)
                                tempTheme.removedEmojis.add(emoji.first!)
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
                ForEach(tempTheme.removedEmojis.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                tempTheme.removedEmojis.remove(emoji.first!)
                                tempTheme.emojis.add(emoji.first!)
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
    
    private var numberOfCards: some View {
        Section {
            Stepper("Pairs In Game: \(tempTheme.numberOfPairs)", value: $tempTheme.numberOfPairs, in: tempTheme.emojis.count < 2 ? 2...2 : 2...tempTheme.emojis.count)
                .onChange(of: tempTheme.numberOfPairs) { oldValue, newValue in
                    tempTheme.numberOfPairs = max(2, min(newValue, tempTheme.emojis.count))
                }
        } header: {
            Text("Max available quantity: \(tempTheme.emojis.count)")
        }
    }
    
    private func isInGame(_ emoji: String) -> Bool {
        tempTheme.emojis.prefix(tempTheme.numberOfPairs).contains(emoji)
    }
    
    private var isEmptyRemoved: Bool {
        tempTheme.removedEmojis.isEmpty
    }
    
    private var isCorrectEmojiCount: Bool {
        tempTheme.emjisCount > 1
    }
    
    private struct Constants {
        struct Size {
            static let width: CGFloat = 30
            static let height: CGFloat = 30
        }
    }
}

struct Preview: View {
    @State private var theme = ThemeStore(named: "Preview").themes.first!
    
    var body: some View {
        ThemeEditor($theme)
    }
}

#Preview {
   Preview()
}
