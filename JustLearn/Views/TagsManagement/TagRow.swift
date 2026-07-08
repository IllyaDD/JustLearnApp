//
//  TagRow.swift
//  JustLearn
//
//  Created by Illya Donchenko on 29.06.2026.
//

import SwiftUI

struct TagRow: View {
    let tag: Tag
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(tag.color.color)
                .frame(width: 14, height: 14)
            Text(tag.name)
            Spacer()
            if !tag.words.isEmpty {
                Text("\(tag.words.count)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.green)
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
