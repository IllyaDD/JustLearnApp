//
//  CardView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 23.06.2026.
//

import SwiftUI
import SwiftData

struct CardView: View {
    @Environment(\.modelContext)private var modelContext
    @Query private var words: [Word]
    
    @State private var topIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var dragOffset: CGSize = .zero

    init() {
        var descriptor = FetchDescriptor<Word>(
            predicate: #Predicate<Word> { word in
                word.timestoStudy > word.timesStudied
            },
            sortBy: [SortDescriptor(\.timesStudied, order: .forward)]
        )
        descriptor.fetchLimit = 30
        _words = Query(descriptor)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(visibleIndices, id: \.self) { index in
                    let depth = index - topIndex
                    let isTop = depth == 0
                    CardFace(for: words[index])
                        .frame(width: geo.size.width * 0.8,
                               height: geo.size.height * 0.7)
                        .offset(x: isTop ? dragOffset.width : 0,
                                y: CGFloat(depth) * 10 + (isTop ? dragOffset.height : 0))
                        .rotationEffect(.degrees(isTop ? Double(dragOffset.width / 20) : 0))
                        .scaleEffect(1 - CGFloat(depth) * 0.05)
                        .zIndex(Double(-depth))
                        .onTapGesture {
                            guard isTop else { return }
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                isFlipped.toggle()
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard isTop else { return }
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    guard isTop else { return }
                                    if abs(value.translation.width) > 120 {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            topIndex += 1
                                            dragOffset = .zero
                                            isFlipped = false
                                        }
                                    } else {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            
            
            

        }
    }

    private var visibleIndices: [Int] {
        let end = min(topIndex + 3, words.count)
        return Array(topIndex..<end)
    }
    private func CardFace(for word: Word) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay {
                Text(word.originalSpelling)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(isFlipped ? 0 : 1)
            }
            .overlay {
                Text(word.translation)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .opacity(isFlipped ? 1 : 0)
            }
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
}

#Preview {
    CardView()
        .modelContainer(for: Word.self, inMemory: true)
}
