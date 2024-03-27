//
//  Extensions+Color+Array.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import SwiftUI
import UIKit

extension Color {
    init(rgba: RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
    
    var name: String {
        UIColor(self).accessibilityName
            .split(separator: " ")
            .map { $0.prefix(1).capitalized + $0.dropFirst() }
            .joined(separator:" ")
    }
    
}

extension View {
    
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        return .zero
    }
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func fillText(_ color: Color, radius: CGFloat, opacity: CGFloat = 0.1) -> some View {
        self
            .padding()
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(color.opacity(opacity))
            }
    }
}
