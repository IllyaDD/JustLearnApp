//
//  AddWordSheet.swift
//  JustLearn
//

import SwiftUI

struct AddWordSheet: View {
    @Environment(\.dismiss) private var dismiss

    let onSave: (_ originalSpelling: String, _ translation: String, _ notes: String, _ timesToLearn: Int) -> Void

    @State private var originalSpelling: String = ""
    @State private var translation: String = ""
    @State private var notes: String = ""
    @State private var timesToLearn: Int = 1

    var body: some View {
        NavigationStack {
            Form {
                TextField("Original spelling", text: $originalSpelling)
                TextField("Translation", text: $translation)
                TextField("Notes", text: $notes)
                Picker("Times to learn", selection: $timesToLearn) {
                    ForEach(1...10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
            .navigationTitle("Add word")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(originalSpelling, translation, notes, timesToLearn)
                        dismiss()
                    }
                    .disabled(originalSpelling.isEmpty || translation.isEmpty)
                }
            }
        }
    }
}
