//
//  MultipleChoiceView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean multiple choice design
//

import SwiftUI

struct MultipleChoiceView: View {
    let challenge: Challenge
    let onAnswer: (String) -> Void

    @State private var selectedAnswer: String? = nil

    private var allOptions: [String] {
        var options = challenge.wrongAnswers ?? []
        options.append(challenge.correctAnswer)
        return options.shuffled()
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(allOptions, id: \.self) { option in
                Button(action: {
                    selectedAnswer = option
                    onAnswer(option)
                }) {
                    HStack {
                        Text(option)
                            .font(DesignSystem.Typography.body())
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if selectedAnswer == option {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(DesignSystem.Colors.accent)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(DesignSystem.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(
                                selectedAnswer == option
                                    ? DesignSystem.Colors.accent
                                    : DesignSystem.Colors.borderDefault,
                                lineWidth: selectedAnswer == option ? 1.5 : 1
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    let challenge = Challenge(
        questionText: "Which director is known for 'The Godfather'?",
        questionType: .multipleChoice,
        correctAnswer: "Francis Ford Coppola",
        wrongAnswers: ["Martin Scorsese", "Steven Spielberg", "Quentin Tarantino"],
        difficulty: .medium,
        xpReward: 15
    )

    MultipleChoiceView(challenge: challenge) { answer in
        print("Selected: \(answer)")
    }
    .padding()
    .background(DesignSystem.Colors.screenBackground)
}
