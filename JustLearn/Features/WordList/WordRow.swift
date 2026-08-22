//
//  WordRow.swift
//  JustLearn
//

import SwiftUI

struct WordRow: View {
    let word: Word
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onResetProgress: () -> Void

    private var tags: [Tag] {
        word.tags ?? []
    }

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 8) {
                Text(word.originalSpelling)
                    .textStyleOriginal()

                if !tags.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(tags.prefix(3)) { tag in
                            Text(tag.name)
                                .font(.caption2.weight(.medium))
                                .lineLimit(1)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(tag.color.color, in: Capsule())
                                .foregroundStyle(tag.color.foregroundColor)
                        }
                        if tags.count > 3 {
                            Text("+\(tags.count - 3)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Spacer()

            Text(word.translation)
                .textStyleSecondary()

            Spacer()
        }
        .swipeActions(edge: .leading) {
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.green)

            Button {
                onResetProgress()
            } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .tint(.orange)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
