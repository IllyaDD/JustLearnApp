//
//  OnboardingBottomButton.swift
//  JustLearn
//
//  Created by Illya Donchenko on 28.06.2026.
//

import SwiftUI

struct OnboardingBottomButton: View {
    let title: String
    let isPrimary: Bool
    let showsArrow: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(isPrimary ? Color(.systemBackground) : .primary)
                if showsArrow {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.headline)
                            .foregroundStyle(isPrimary ? Color(.systemBackground) : .primary)
                    }
                    .padding(.horizontal, 28)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(isPrimary ? Color.primary : Color(.systemGray6))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
