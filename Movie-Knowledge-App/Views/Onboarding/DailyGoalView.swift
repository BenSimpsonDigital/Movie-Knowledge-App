//
//  DailyGoalView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct DailyGoalView: View {
    @Binding var selectedGoal: Int
    var onContinue: () -> Void

    @State private var showContent = false

    private let goalOptions: [(questions: Int, title: String, description: String, icon: String)] = [
        (3, "Casual", "A quick daily refresh", "leaf"),
        (5, "Regular", "Balanced learning pace", "flame"),
        (10, "Intense", "Fast-track your knowledge", "bolt.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Header
            VStack(spacing: 12) {
                Image(systemName: "target")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                    .padding(.bottom, 8)

                Text("Set your daily goal")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)

                Text("How many questions do you want to answer each day?")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .opacity(showContent ? 1.0 : 0.0)

            Spacer()

            // Goal options
            VStack(spacing: 16) {
                ForEach(goalOptions, id: \.questions) { option in
                    GoalOptionCard(
                        questions: option.questions,
                        title: option.title,
                        description: option.description,
                        icon: option.icon,
                        isSelected: selectedGoal == option.questions
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedGoal = option.questions
                            HapticManager.shared.light()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .opacity(showContent ? 1.0 : 0.0)
            .offset(y: showContent ? 0 : 20)

            Spacer()
            Spacer()

            // CTA Button
            Button(action: {
                HapticManager.shared.medium()
                onContinue()
            }) {
                Text("Continue")
                    .depthButtonLabel(font: .system(size: 18, weight: .semibold), verticalPadding: 18)
            }
            .buttonStyle(DepthButtonStyle(cornerRadius: 16))
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(showContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

// MARK: - Goal Option Card

struct GoalOptionCard: View {
    let questions: Int
    let title: String
    let description: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(isSelected ? .white : .blue)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : Color.blue.opacity(0.1))
                    )

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)

                        Spacer()

                        Text("\(questions) questions")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(isSelected ? .blue : .secondary)
                    }

                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.blue)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: .black.opacity(isSelected ? 0.08 : 0.04), radius: isSelected ? 12 : 8, y: isSelected ? 6 : 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DailyGoalView(
        selectedGoal: .constant(5),
        onContinue: {}
    )
}
