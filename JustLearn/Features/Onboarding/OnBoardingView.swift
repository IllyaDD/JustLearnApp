//
//  OnBoardingView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 28.06.2026.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var page: Int = 0

    private let pageCount = 4

    var body: some View {
        VStack(spacing: 0) {
            OnboardingPageIndicator(current: page, total: pageCount)
                .padding(.top, 12)
                .padding(.bottom, 8)

            TabView(selection: $page) {
                OnboardingPage(
                    icon: "hand.wave",
                    title: "Welcome to\nJustLearn",
                    subtitle: "Here you can learn new words at your own pace."
                )
                .tag(0)

                OnboardingPage(
                    icon: "book.closed",
                    title: "Learn new\nwords",
                    subtitle: "Practise vocabulary with cards and writing exercises."
                )
                .tag(1)

                NotificationsPage().tag(2)

                PrivacyPage().tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: page)

            OnboardingBottomButton(
                title: page < pageCount - 1 ? "Continue" : "Get Started",
                isPrimary: page == pageCount - 1,
                showsArrow: page < pageCount - 1
            ) {
                if page < pageCount - 1 {
                    withAnimation { page += 1 }
                } else {
                    hasSeenOnboarding = true
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}

struct OnboardingPageIndicator: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.primary : Color.secondary.opacity(0.3))
                    .frame(width: index == current ? 22 : 6, height: 6)
                    .animation(.easeInOut, value: current)
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
