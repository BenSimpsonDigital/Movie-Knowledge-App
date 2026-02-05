//
//  FillBlankView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean fill-in-blank design
//

import SwiftUI

struct FillBlankView: View {
    let challenge: Challenge
    let onAnswer: (String) -> Void

    @State private var userInput: String = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            // Text input field
            VStack(alignment: .leading, spacing: 6) {
                Text("Your answer")
                    .font(DesignSystem.Typography.caption())
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
                    .textCase(.uppercase)
                    .tracking(0.5)

                TextField("Type your answer...", text: $userInput)
                    .font(DesignSystem.Typography.body())
                    .padding(14)
                    .background(DesignSystem.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(
                                isTextFieldFocused
                                    ? DesignSystem.Colors.accent
                                    : DesignSystem.Colors.borderDefault,
                                lineWidth: isTextFieldFocused ? 1.5 : 1
                            )
                    )
                    .focused($isTextFieldFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
            }

            // Submit button
            Button(action: {
                guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                isTextFieldFocused = false
                onAnswer(userInput)
            }) {
                Text("Submit")
                    .depthButtonLabel()
            }
            .buttonStyle(DepthButtonStyle(cornerRadius: 10))
            .disabled(userInput.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    let challenge = Challenge(
        questionText: "Who directed 'Pulp Fiction'?",
        questionType: .fillBlank,
        correctAnswer: "Quentin Tarantino",
        difficulty: .medium,
        xpReward: 15
    )

    FillBlankView(challenge: challenge) { answer in
        print("Submitted: \(answer)")
    }
    .padding()
    .background(DesignSystem.Colors.screenBackground)
}
