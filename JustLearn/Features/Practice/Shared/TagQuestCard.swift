//
//  TagQuestCard.swift
//  JustLearn
//

import SwiftUI

struct TagQuestStats {
    let total: Int
    let learned: Int

    var remaining: Int { max(0, total - learned) }
    var progress: Double {
        guard total > 0 else { return 0 }
        return min(1.0, Double(learned) / Double(total))
    }
}

struct TagQuestCard: View {
    let title: String
    let accent: Color
    let systemImage: String?
    let stats: TagQuestStats
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                progressRing
                    .padding(14)

                VStack(alignment: .leading, spacing: 6) {
                    if let systemImage {
                        Image(systemName: systemImage)
                            .font(.title3)
                            .foregroundStyle(accent)
                    } else {
                        Circle()
                            .fill(accent)
                            .frame(width: 10, height: 10)
                    }
                    Spacer(minLength: 0)
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(14)
            }
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accent.opacity(0.18), accent.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? accent : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSelected)
            .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var subtitle: String {
        if stats.total == 0 {
            return "No words"
        }
        if stats.remaining == 0 {
            return "All \(stats.total) learned"
        }
        return "\(stats.remaining) to review · \(stats.total) total"
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(accent.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: stats.progress)
                .stroke(accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(stats.progress * 100))%")
                .font(.caption2.weight(.bold))
                .foregroundStyle(accent)
        }
        .frame(width: 40, height: 40)
    }
}

#Preview {
    HStack(spacing: 12) {
        TagQuestCard(
            title: "All words",
            accent: .gray,
            systemImage: "books.vertical.fill",
            stats: TagQuestStats(total: 30, learned: 12),
            isSelected: false,
            action: {}
        )
        TagQuestCard(
            title: "Verbs",
            accent: .blue,
            systemImage: nil,
            stats: TagQuestStats(total: 15, learned: 8),
            isSelected: true,
            action: {}
        )
    }
    .padding()
}
