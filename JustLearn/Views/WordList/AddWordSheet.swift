//
//  AddWordSheet.swift
//  JustLearn
//

import SwiftUI

struct AddWordSheet: View {
    @Environment(\.dismiss) private var dismiss

    let onSave: (_ originalSpelling: String, _ translation: String, _ tags: [Tag], _ timesToLearn: Int) -> Void

    @State private var originalSpelling: String = ""
    @State private var translation: String = ""
    @State private var selectedTags: [Tag] = []
    @State private var timesToLearn: Int = 1

    private var isFormValid: Bool {
        !originalSpelling.isEmpty
        && !translation.isEmpty
        && !WordValidation.isTooLong(originalSpelling)
        && !WordValidation.isTooLong(translation)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Original spelling", text: $originalSpelling)
                } footer: {
                    if WordValidation.isTooLong(originalSpelling) {
                        Text(WordValidation.message(for: .original))
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    TextField("Translation", text: $translation)
                } footer: {
                    if WordValidation.isTooLong(translation) {
                        Text(WordValidation.message(for: .translation))
                            .foregroundStyle(.red)
                    }
                }

                Section("Tags") {
                    NavigationLink {
                        TagPickerView(selectedTags: $selectedTags)
                    } label: {
                        TagPickerLabel(selectedTags: selectedTags)
                    }
                }

                Picker("Times to learn", selection: $timesToLearn) {
                    ForEach(1...10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
#if targetEnvironment(macCatalyst)
            .navigationTitle("Just Learn")
#else
            .navigationTitle("Add word")
#endif
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(originalSpelling, translation, selectedTags, timesToLearn)
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}
