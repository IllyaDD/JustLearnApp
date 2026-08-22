//
//  TagFilterBar.swift
//  JustLearn
//
//  Created by Illya Donchenko on 03.07.2026.
//

import SwiftUI

struct TagFilterBar: View {
    let tags: [Tag]
    let counts: [UUID: Int]
    @Binding var selectedTagID: UUID?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                pill(title: "All", count: nil, isSelected: selectedTagID == nil) {
                    selectedTagID = nil
                }
                ForEach(tags) { tag in
                    pill(
                        title: tag.name,
                        count: counts[tag.id],
                        isSelected: selectedTagID == tag.id
                    ) {
                        selectedTagID = tag.id
                    }
                }
            }
            .padding(6)
        }
        .background(Capsule().fill(Color.gray.opacity(0.18)))
        .padding(.horizontal)
    }

    @ViewBuilder
    private func pill(title: String, count: Int?, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                if let count, count > 0 {
                    Text("\(count)")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.primary)
                        .frame(minWidth: 20, minHeight: 20)
                        .background(Circle().fill(Color.gray.opacity(0.35)))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(isSelected ? Color.gray.opacity(0.35) : Color.clear)
            )
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
