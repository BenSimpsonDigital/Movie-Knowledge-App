//
//  EmptyStateView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        iconName: String = "tray",
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.iconName = iconName
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            Image(systemName: iconName)
                .font(.system(size: 80))
                .foregroundColor(.secondary.opacity(0.5))

            // Title and message
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)

                Text(message)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            // Optional action button
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding(.vertical, 16)
                        .background(DesignSystem.Colors.primaryButton)
                        .cornerRadius(12)
                }
                .padding(.top, 16)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Colors.screenBackground)
    }
}

#Preview {
    VStack(spacing: 40) {
        EmptyStateView(
            iconName: "book.closed",
            title: "No Lessons Yet",
            message: "Complete the previous lesson to unlock this one"
        )

        EmptyStateView(
            iconName: "star.slash",
            title: "No Badges Earned",
            message: "Complete lessons to earn your first badge",
            actionTitle: "Start Learning"
        ) {
            print("Start learning tapped")
        }
    }
}
