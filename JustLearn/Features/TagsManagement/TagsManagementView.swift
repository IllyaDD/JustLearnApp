//
//  TagsManagementView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 29.06.2026.
//

import SwiftUI
import SwiftData

struct TagsManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tag.createdAt) private var tags: [Tag]
    @State private var showAddSheet = false
    @State private var tagToEdit: Tag?

    var body: some View {
        List {
            ForEach(tags) { tag in
                TagRow(
                    tag: tag,
                    onEdit: { tagToEdit = tag },
                    onDelete: {
                        modelContext.delete(tag)
                        try? modelContext.save()
                    }
                )
            }
        }
        .overlay {
            if tags.isEmpty {
                ContentUnavailableView(
                    "No tags yet",
                    systemImage: "tag",
                    description: Text("Tap + to create your first tag")
                )
            }
        }
        .navigationTitle("Tags")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddTagSheet()
                .presentationDetents([.medium])
        }
        .sheet(item: $tagToEdit) { tag in
            EditTagSheet(tag: tag) {
                tagToEdit = nil
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    NavigationStack {
        TagsManagementView()
    }
    .modelContainer(for: [Tag.self, Word.self], inMemory: true)
}
