//
//  TagPickerView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 29.06.2026.
//

import SwiftUI
import SwiftData

struct TagPickerView: View {
    @Query(sort: \Tag.createdAt) private var allTags: [Tag]
    @Binding var selectedTags: [Tag]

    var body: some View {
        Group {
            if allTags.isEmpty {
                ContentUnavailableView(
                    "No tags yet",
                    systemImage: "tag",
                    description: Text("Create tags in Settings → Tags")
                )
            } else {
                List {
                    ForEach(allTags) { tag in
                        Button {
                            toggle(tag)
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(tag.color.color)
                                    .frame(width: 12, height: 12)
                                Text(tag.name)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if isSelected(tag) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.tint)
                                        .font(.body.weight(.semibold))
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
#if targetEnvironment(macCatalyst)
        .navigationTitle("Just Learn")
#else
        .navigationTitle("Tags")
#endif
        .toolbarTitleDisplayMode(.inline)
    }

    private func isSelected(_ tag: Tag) -> Bool {
        selectedTags.contains(where: { $0.id == tag.id })
    }

    private func toggle(_ tag: Tag) {
        if let index = selectedTags.firstIndex(where: { $0.id == tag.id }) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
}

struct TagPickerLabel: View {
    let selectedTags: [Tag]

    var body: some View {
        if selectedTags.isEmpty {
            Text("Add tags")
                .foregroundStyle(.secondary)
        } else {
            HStack(spacing: 8) {
                ForEach(selectedTags.prefix(3)) { tag in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(tag.color.color)
                            .frame(width: 8, height: 8)
                        Text(tag.name)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
                if selectedTags.count > 3 {
                    Text("+\(selectedTags.count - 3)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
