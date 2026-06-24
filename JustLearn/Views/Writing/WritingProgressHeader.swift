//
//  WritingProgressHeader.swift
//  JustLearn
//

import SwiftUI

struct WritingProgressHeader: View {
    let currentIndex: Int
    let total: Int

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Word \(currentIndex + 1) of \(total)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(fraction * 100))%")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)
                    .contentTransition(.numericText())
            }

            ProgressView(value: fraction)
                .tint(.blue)
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                .animation(.easeInOut, value: fraction)
        }
        .padding(.top, 16)
    }

    private var fraction: Double {
        guard total > 0 else { return 0 }
        return Double(currentIndex) / Double(total)
    }
}

#Preview {
    WritingProgressHeader(currentIndex: 3, total: 15)
        .padding()
}
