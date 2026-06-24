//
//  EditWordSheet.swift
//  JustLearn
//

import SwiftUI

struct EditWordSheet: View {
    @Bindable var word: Word
    let onDone: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Original spelling", text: $word.originalSpelling)
                TextField("Translation", text: $word.translation)
                TextField("Notes", text: $word.notesUnwrapped)
                Picker("Times to learn", selection: $word.timestoStudy) {
                    ForEach(1...10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
            .navigationTitle("Edit word")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDone()
                    }
                }
            }
        }
    }
}
