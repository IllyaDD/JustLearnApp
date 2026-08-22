import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Word.createdAt, order: .reverse) private var words: [Word]
    var body: some View {
        NavigationStack {
            List(words) { word in
                VStack(alignment: .leading, spacing: 2) {
                    Text(word.originalSpelling)
                        .font(.headline)
                    Text(word.translation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Words")
            .overlay {
                if words.isEmpty {
                    ContentUnavailableView(
                        "No words yet",
                        systemImage: "applewatch.radiowaves.left.and.right",
                        description: Text("Add words on your iPhone")
                    )
                }
            }
        }
    }
}
