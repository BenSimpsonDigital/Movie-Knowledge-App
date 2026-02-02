//
//  TrueFalseView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean true/false design
//

import SwiftUI

struct TrueFalseView: View {
    let challenge: Challenge
    let onAnswer: (String) -> Void

    @State private var selectedAnswer: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            // True button
            Button(action: {
                selectedAnswer = "True"
                onAnswer("True")
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(selectedAnswer == "True"
                            ? DesignSystem.Colors.accent
                            : DesignSystem.Colors.textTertiary)

                    Text("True")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(DesignSystem.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            selectedAnswer == "True"
                                ? DesignSystem.Colors.accent
                                : DesignSystem.Colors.borderDefault,
                            lineWidth: selectedAnswer == "True" ? 1.5 : 1
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())

            // False button
            Button(action: {
                selectedAnswer = "False"
                onAnswer("False")
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(selectedAnswer == "False"
                            ? DesignSystem.Colors.accent
                            : DesignSystem.Colors.textTertiary)

                    Text("False")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(DesignSystem.Colors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            selectedAnswer == "False"
                                ? DesignSystem.Colors.accent
                                : DesignSystem.Colors.borderDefault,
                            lineWidth: selectedAnswer == "False" ? 1.5 : 1
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    let challenge = Challenge(
        questionText: "The Godfather was released in 1972.",
        questionType: .trueFalse,
        correctAnswer: "True",
        difficulty: .easy,
        xpReward: 10
    )

    TrueFalseView(challenge: challenge) { answer in
        print("Selected: \(answer)")
    }
    .padding()
    .background(DesignSystem.Colors.screenBackground)
}
