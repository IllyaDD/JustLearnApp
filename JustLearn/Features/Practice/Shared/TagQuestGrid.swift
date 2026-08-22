//
//  TagQuestGrid.swift
//  JustLearn
//

import SwiftUI

struct TagQuestGrid: View {
    let tags: [Tag]
    let allWords: [Word]
    @Binding var selectedTagID: UUID?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                TagQuestCard(
                    title: "All words",
                    accent: .gray,
                    systemImage: "books.vertical.fill",
                    stats: stats(for: nil),
                    isSelected: selectedTagID == nil,
                    action: { selectedTagID = nil }
                )

                ForEach(tags) { tag in
                    TagQuestCard(
                        title: tag.name,
                        accent: tag.color.color,
                        systemImage: nil,
                        stats: stats(for: tag),
                        isSelected: selectedTagID == tag.id,
                        action: { selectedTagID = tag.id }
                    )
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
    }

    private func stats(for tag: Tag?) -> TagQuestStats {
        let scoped: [Word]
        if let tag {
            scoped = allWords.filter { $0.tags?.contains(where: { $0.id == tag.id }) ?? false }
        } else {
            scoped = allWords
        }
        let total = scoped.count
        let learned = scoped.filter { $0.timesStudied >= $0.timestoStudy && $0.timestoStudy > 0 }.count
        return TagQuestStats(total: total, learned: learned)
    }
}
