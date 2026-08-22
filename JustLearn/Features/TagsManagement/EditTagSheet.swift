//
//  EditTagSheet.swift
//  JustLearn
//
//  Created by Illya Donchenko on 29.06.2026.
//

import SwiftUI
import SwiftData

struct EditTagSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var existingTags: [Tag]
    @Bindable var tag: Tag
    let onDone: () -> Void

    private var trimmedName: String {
        tag.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isNameTooLong: Bool {
        tag.name.count > Constans.maxTagNameLength
    }

    private var isDuplicate: Bool {
        guard !trimmedName.isEmpty else { return false }
        return existingTags.contains { other in
            other.id != tag.id
                && other.name.caseInsensitiveCompare(trimmedName) == .orderedSame
                && other.color == tag.color
        }
    }

    private var isFormValid: Bool {
        !trimmedName.isEmpty && !isNameTooLong && !isDuplicate
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("e.g. Food, Verbs, Travel", text: $tag.name)
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
                            ColorSwitch(
                                tagColor: tagColor,
                                isSelected: tag.color == tagColor
                            )
                            .onTapGesture {
                                tag.color = tagColor
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
            .navigationTitle("Edit Tag")
#endif
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        tag.name = trimmedName
                        try? modelContext.save()
                        onDone()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}
