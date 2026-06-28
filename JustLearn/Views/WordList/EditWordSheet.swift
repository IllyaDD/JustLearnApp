//
//  EditWordSheet.swift
//  JustLearn
//

import SwiftUI

struct EditWordSheet: View {
    @Bindable var word: Word
    let onDone: () -> Void

    private var isFormValid: Bool {
        !word.originalSpelling.isEmpty
        && !word.translation.isEmpty
        && !WordValidation.isTooLong(word.originalSpelling)
        && !WordValidation.isTooLong(word.translation)
        && !WordValidation.isTooLong(word.notesUnwrapped)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Original spelling", text: $word.originalSpelling)
                } footer: {
                    if WordValidation.isTooLong(word.originalSpelling) {
                        Text(WordValidation.message(for: .original))
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    TextField("Translation", text: $word.translation)
                } footer: {
                    if WordValidation.isTooLong(word.translation) {
                        Text(WordValidation.message(for: .translation))
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    TextField("Notes", text: $word.notesUnwrapped)
                } footer: {
                    if WordValidation.isTooLong(word.notesUnwrapped) {
                        Text(WordValidation.message(for: .notes))
                            .foregroundStyle(.red)
                    }
                }

                Picker("Times to learn", selection: $word.timestoStudy) {
                    ForEach(1...10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .onChange(of: word.timestoStudy) {
                    word.timesStudied = 0
                }
            }
            .navigationTitle("Edit word")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDone()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}
