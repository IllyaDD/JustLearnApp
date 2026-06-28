//
//  PrivacyPage.swift
//  JustLearn
//
//  Created by Illya Donchenko on 28.06.2026.
//

import SwiftUI

struct PrivacyPage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 40, weight: .regular))
                .foregroundStyle(.primary)
            Text("You're all set!")
                .font(.system(size: 40, weight: .bold))
                .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 18) {
                OnboardingFeatureRow(
                    icon: "lock",
                    text: "Your data is fully private"
                )
                OnboardingFeatureRow(
                    icon: "icloud",
                    text: "iCloud synchronization is active"
                )
                OnboardingFeatureRow(
                    icon: "rectangle.portrait.on.rectangle.portrait.angled",
                    text: "Cards and writing modes are ready"
                )
            }
            .padding(.top, 8)
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}
