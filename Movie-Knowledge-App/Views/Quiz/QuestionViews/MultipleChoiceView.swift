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
                let isSelected = selectedAnswer == option
                Button(action: {
                    selectedAnswer = option
                    onAnswer(option)
                }) {
                    HStack {
                        Text(option)
                            .font(DesignSystem.Typography.body())
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(DepthButtonStyle(
                    fill: isSelected
                        ? DesignSystem.Colors.primaryButton
                        : DesignSystem.Colors.primaryButton.opacity(0.85),
                    base: isSelected
                        ? DesignSystem.Colors.buttonDepthBase
                        : DesignSystem.Colors.buttonDepthBase.opacity(0.85),
                    cornerRadius: 10
                ))
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
