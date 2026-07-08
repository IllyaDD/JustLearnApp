//
//  AddTagSheet.swift
//  JustLearn
//
//  Created by Illya Donchenko on 29.06.2026.
//

import SwiftUI
import SwiftData

struct AddTagSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var existingTags: [Tag]

    @State private var name: String = ""
    @State private var selectedColor: TagColor = .blue

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isNameTooLong: Bool {
        name.count > Constans.maxTagNameLength
    }

    private var isDuplicate: Bool {
        guard !trimmedName.isEmpty else { return false }
        return existingTags.contains { tag in
            tag.name.caseInsensitiveCompare(trimmedName) == .orderedSame
                && tag.color == selectedColor
        }
    }

    private var isFormValid: Bool {
        !trimmedName.isEmpty && !isNameTooLong && !isDuplicate
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("e.g. Food, Verbs, Travel", text: $name)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Name")
                } footer: {
                    if isNameTooLong {
                        Text("Tag name must be \(Constans.maxTagNameLength) characters or fewer.")
                            .foregroundStyle(.red)
                    } else if isDuplicate {
                        Text("A tag with this name and color already exists.")
                            .foregroundStyle(.red)
                    }
                }
                Section("Color") {
                    HStack(spacing: 14) {
                        ForEach(TagColor.allCases) { tagColor in
                            ColorSwatch(
                                tagColor: tagColor,
                                isSelected: selectedColor == tagColor
                            )
                            .onTapGesture {
                                selectedColor = tagColor
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
            }
#if targetEnvironment(macCatalyst)
            .navigationTitle("Just Learn")
#else
            .navigationTitle("New Tag")
#endif
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: save)
                        .disabled(!isFormValid)
                }
            }
        }
    }

    private func save() {
        guard !trimmedName.isEmpty else { return }
        let tag = Tag(name: trimmedName, color: selectedColor)
        modelContext.insert(tag)
        try? modelContext.save()
        dismiss()
    }
}
