//
//  NotificationsPage.swift
//  JustLearn
//
//  Created by Illya Donchenko on 28.06.2026.
//

import SwiftUI

struct NotificationsPage: View {
    @State private var asked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            Spacer()
            Image(systemName: "bell.badge")
                .font(.system(size: 36, weight: .regular))
                .foregroundStyle(.primary)
            Text("Stay\nConsistent")
                .font(.system(size: 40, weight: .bold))
            Text("Allow notifications so we can remind you to practise every day.")
                .font(.title3)
                .foregroundStyle(.secondary)
            Button {
                requestPermission()
                asked = true
            } label: {
                Text(asked ? "Requested" : "Allow Notifications")
                    .font(.headline)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 24)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(asked)
            .padding(.top, 8)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
    }
}
