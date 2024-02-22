//
//  EditableThemesList.swift
//  Memorize
//
//  Created by Саша Восколович on 21.02.2024.
//

import SwiftUI

struct EditableThemesList: View {
    
    @ObservedObject var store: ThemeStore
    @State private var showEditor: Bool = false
    @State private var choosenTheme: Theme?
    
    
    
    var body: some View {
        List {
            ForEach(store.themes) { theme in
                ThemeView(theme: theme)
                    .onTapGesture {
                        choosenTheme = theme
                    }
            }
            .onDelete { indexSet in
                store.themes.remove(atOffsets: indexSet)
            }
            .onMove { indexSet, newOffset in
                store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
            }
        }
        .sheet(isPresented: $showEditor, onDismiss: {
            choosenTheme = nil
            if let theme = store.themes.first, theme.emjisCount < 2 {
                store.remove(theme)
            }
        }, content:  {
            if let choosenTheme {
                ThemeEditor($store.themes[choosenTheme])
            }
        })
        .onChange(of: choosenTheme) { _ , newValue in
            showEditor = newValue != nil
        }
        .toolbar {
            Button {
                store.insert(name: "", emojis: "")
                choosenTheme = store.themes.first!
            } label: {
                Image(systemName: "plus")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.blue.gradient, in: .circle)
                    .contentShape(.circle)
            }
        }
    }
}


#Preview {
    NavigationStack {
        EditableThemesList(store: ThemeStore(named: "Preview"))
    }
}
