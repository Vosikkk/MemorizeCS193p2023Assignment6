//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Саша Восколович on 18.02.2024.
//

import SwiftUI


struct FlyingNumber: View {
    
    let number: Int
    @State private var offset: CGFloat = 0
    
    
    var body: some View {
        
        if number != 0 {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundStyle(number < 0 ? .red : .orange)
                .shadow(color: .black, radius: Constants.shadowRadius, x: Constants.positionX, y: Constants.positionY)
                .offset(x: 0, y: offset)
            
            // Change in movement
                .opacity(offset != 0 ? 0 : 1)
                .onAppear {
                    withAnimation(.easeInOut(duration: Constants.Animation.duration)) {
                        offset = number < 0 ? Constants.Offset.moveDown : Constants.Offset.moveUp
                    }
                }
                .onDisappear {
                    offset = 0
                }
        }
    }
    
    
    private struct Constants {
        static let shadowRadius: CGFloat = 1.5
        static let positionX: CGFloat = 1
        static let positionY: CGFloat = 1
        
        struct Offset {
            static let moveUp: CGFloat = -200
            static let moveDown: CGFloat = 200
        }
        struct Animation {
            static let duration: CGFloat = 1.6
        }
    }
}
