//
//  WordRow.swift
//  JustLearn
//

import SwiftUI

struct WordRow: View {
    let word: Word
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack {
            Text(word.originalSpelling)
                .textStyleOriginal()

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
