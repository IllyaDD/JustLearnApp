//
//  CardStackView.swift
//  JustLearn
//

import SwiftUI

struct CardStackView: View {
    let words: [Word]
    let currentIndex: Int
    let direction: learningDestination
    let onRemembered: (Word) -> Void
    let onForgotten: (Word) -> Void
    let onAdvance: () -> Void

    @State private var isFlipped: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var isTransitioning: Bool = false
    private let swipeThreshold: CGFloat = 120

    private var swipeProgress: CGFloat {
        max(-1, min(1, dragOffset.width / swipeThreshold))
    }

    private var visibleIndices: [Int] {
        guard currentIndex < words.count else { return [] }
        let end = min(currentIndex + 3, words.count)
        return Array(currentIndex..<end)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(visibleIndices, id: \.self) { index in
                    let depth = index - currentIndex
                    let isTop = depth == 0
                    CardFace(word: words[index],
                             direction: direction,
                             isFlipped: isTop && isFlipped,
                             swipeProgress: isTop ? swipeProgress : 0)
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
                                    guard isTop, !isTransitioning else { return }
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    guard isTop, !isTransitioning else { return }
                                    guard currentIndex < words.count else { return }
                                    let word = words[currentIndex]
                                    if value.translation.width > swipeThreshold {
                                        onRemembered(word)
                                        advanceCard(direction: 1)
                                    } else if value.translation.width < -swipeThreshold {
                                        onForgotten(word)
                                        advanceCard(direction: -1)
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

    private func advanceCard(direction: CGFloat) {
        isTransitioning = true
        withAnimation(.easeOut(duration: 0.22)) {
            dragOffset.width = direction * 800
        }
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(220))
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                onAdvance()
                dragOffset = .zero
                isFlipped = false
            }
            isTransitioning = false
        }
    }
}
