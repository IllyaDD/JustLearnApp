//
//  ColorSwatch.swift
//  JustLearn
//
//  Created by Illya Donchenko on 29.06.2026.
//

import SwiftUI

struct ColorSwitch: View {
    let tagColor: TagColor
    let isSelected: Bool

    var body: some View {
        Circle()
            .fill(tagColor.color)
            .frame(width: 30, height: 30)
            .overlay {
                Circle()
                    .stroke(Color.primary, lineWidth: isSelected ? 2 : 0)
                    .padding(-4)
            }
            .accessibilityLabel(tagColor.displayName)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
