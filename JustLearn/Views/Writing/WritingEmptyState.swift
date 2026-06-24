//
//  WritingEmptyState.swift
//  JustLearn
//

import SwiftUI

struct WritingEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green.gradient)
            Text("No words to learn")
                .font(.title2.weight(.semibold))
            Text("Add new words to start practicing")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

#Preview {
    WritingEmptyState()
}
