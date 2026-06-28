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

    @State private var queue: [Word] = []
    @State private var topIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var dragOffset: CGSize = .zero
    private let swipeThreshold: CGFloat = 120
    private var swipeProgress: CGFloat {
        max(-1, min(1, dragOffset.width / swipeThreshold))
    }
    @State private var isSessionActive: Bool = false
    @State private var isTransitioning: Bool = false
    @AppStorage("practiseDirection") private var practiseDirection: learningDestination = .TranslateToOriginal

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
        VStack(spacing: 0) {
            if words.isEmpty {
                WritingEmptyState()
            } else if !isSessionActive {
                startScreen
            } else if topIndex < queue.count {
                WritingProgressHeader(currentIndex: topIndex, total: queue.count)
                cardStack
            } else {
                WritingCompletedState(
                    title: "Cards practice completed",
                    totalWords: queue.count,
                    onRestart: startSession
                )
            }
        }
        .padding(.horizontal, 20)
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
    
    
    private var startScreen: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "rectangle.on.rectangle.angled")
                .font(.system(size: 64))
                .foregroundStyle(.blue.gradient)
            Text("Cards practice")
                .font(.title2.weight(.semibold))
            Text("\(words.count) words ready to practice")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Button {
                startSession()
            } label: {
                Label("Start practice", systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom, 24)
        }
    }

    private var cardStack: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(visibleIndices, id: \.self) { index in
                    let depth = index - topIndex
                    let isTop = depth == 0
                    CardFace(for: queue[index],
                             swipeProgress: isTop ? swipeProgress:0)
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
                                    guard topIndex < queue.count else { return }
                                    if value.translation.width > 120 {
                                        queue[topIndex].timesStudied += 1
                                        try? modelContext.save()
                                        advanceCard(direction: 1)
                                    } else if value.translation.width < -120 {
                                        queue[topIndex].timesStudied =  max(0,queue[topIndex].timesStudied - 1 )
                                        try? modelContext.save()
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

    private var visibleIndices: [Int] {
        guard topIndex < queue.count else { return [] }
        let end = min(topIndex + 3, queue.count)
        return Array(topIndex..<end)
    }
    private func CardFace(for word: Word, swipeProgress: CGFloat = 0) -> some View {
        let strokeColor: Color = swipeProgress > 0 ? .green : .red
        let frontText = practiseDirection == .OriginalToTranslate ? word.originalSpelling : word.translation
        let backText  = practiseDirection == .OriginalToTranslate ? word.translation : word.originalSpelling
        return RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(strokeColor, lineWidth: abs(swipeProgress) * 4)
            }
            .overlay {
                Text(frontText)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(isFlipped ? 0 : 1)
            }
            .overlay {
                Text(backText)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .opacity(isFlipped ? 1 : 0)
            }
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
    
    

    private func startSession() {
        queue = words.shuffled()
        topIndex = 0
        isFlipped = false
        dragOffset = .zero
        isTransitioning = false
        isSessionActive = true
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
                topIndex += 1
                dragOffset = .zero
                isFlipped = false
            }
            isTransitioning = false
        }
    }
}

#Preview {
    CardView()
        .modelContainer(for: Word.self, inMemory: true)
}
