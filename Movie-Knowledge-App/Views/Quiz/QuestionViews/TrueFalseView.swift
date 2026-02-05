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
                        .foregroundStyle(.white)

                    Text("True")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            }
            .buttonStyle(DepthButtonStyle(
                fill: selectedAnswer == "True"
                    ? DesignSystem.Colors.primaryButton
                    : DesignSystem.Colors.primaryButton.opacity(0.85),
                base: selectedAnswer == "True"
                    ? DesignSystem.Colors.buttonDepthBase
                    : DesignSystem.Colors.buttonDepthBase.opacity(0.85),
                cornerRadius: 12
            ))

            // False button
            Button(action: {
                selectedAnswer = "False"
                onAnswer("False")
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)

                    Text("False")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            }
            .buttonStyle(DepthButtonStyle(
                fill: selectedAnswer == "False"
                    ? DesignSystem.Colors.primaryButton
                    : DesignSystem.Colors.primaryButton.opacity(0.85),
                base: selectedAnswer == "False"
                    ? DesignSystem.Colors.buttonDepthBase
                    : DesignSystem.Colors.buttonDepthBase.opacity(0.85),
                cornerRadius: 12
            ))
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
