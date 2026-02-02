//
//  MatchDirectorView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct MatchDirectorView: View {
    let challenge: Challenge
    let onAnswer: (String) -> Void

    @State private var selectedDirector: String?
    @State private var hasSubmitted = false

    // Parse the challenge to extract directors and films
    // Expected format for correctAnswer: "DirectorName"
    // Expected format for wrongAnswers: other director names
    private var directors: [String] {
        var allDirectors = challenge.wrongAnswers ?? []
        allDirectors.append(challenge.correctAnswer)
        return allDirectors.shuffled()
    }

    var body: some View {
        VStack(spacing: 24) {
            // Instructions
            Text("Select the correct director")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            // Director options
            VStack(spacing: 12) {
                ForEach(directors, id: \.self) { director in
                    DirectorOptionButton(
                        name: director,
                        isSelected: selectedDirector == director,
                        isDisabled: hasSubmitted
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedDirector = director
                        }
                        HapticManager.shared.light()
                    }
                }
            }

            Spacer(minLength: 20)

            // Submit button
            Button(action: {
                guard let selected = selectedDirector else { return }
                hasSubmitted = true
                HapticManager.shared.medium()
                onAnswer(selected)
            }) {
                Text("Confirm Selection")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedDirector != nil ? Color.blue : Color.gray.opacity(0.4))
                    )
            }
            .disabled(selectedDirector == nil || hasSubmitted)
            .opacity(hasSubmitted ? 0.6 : 1.0)
        }
    }
}

// MARK: - Director Option Button

struct DirectorOptionButton: View {
    let name: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Director icon
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? .white : .blue)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : Color.blue.opacity(0.1))
                    )

                // Name
                Text(name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(isSelected ? .white : .primary)

                Spacer()

                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: isSelected ? 0 : 1)
            )
            .shadow(color: .black.opacity(isSelected ? 0.1 : 0.04), radius: isSelected ? 12 : 8, y: isSelected ? 6 : 4)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

#Preview {
    let challenge = Challenge(
        questionText: "Who directed 'Psycho' (1960)?",
        questionType: .matchDirector,
        correctAnswer: "Alfred Hitchcock",
        wrongAnswers: ["Stanley Kubrick", "Billy Wilder", "John Ford"],
        explanation: "Alfred Hitchcock directed Psycho in 1960.",
        difficulty: .medium
    )

    return MatchDirectorView(challenge: challenge) { answer in
        print("Selected: \(answer)")
    }
    .padding()
}
