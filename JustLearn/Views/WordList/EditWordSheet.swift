//
//  EditWordSheet.swift
//  JustLearn
//

import SwiftUI

struct EditWordSheet: View {
    @Bindable var word: Word
    let onDone: () -> Void

    private var tagsBinding: Binding<[Tag]> {
        Binding(
            get: { word.tags ?? [] },
            set: { word.tags = $0 }
        )
    }

    private var isFormValid: Bool {
        !word.originalSpelling.isEmpty
        && !word.translation.isEmpty
        && !WordValidation.isTooLong(word.originalSpelling)
        && !WordValidation.isTooLong(word.translation)
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

                Section("Tags") {
                    NavigationLink {
                        TagPickerView(selectedTags: tagsBinding)
                    } label: {
                        TagPickerLabel(selectedTags: word.tags ?? [])
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
#if targetEnvironment(macCatalyst)
            .navigationTitle("Just Learn")
#else
            .navigationTitle("Edit word")
#endif
            .toolbarTitleDisplayMode(.inline)
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
