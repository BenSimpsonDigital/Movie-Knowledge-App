//
//  PickYearView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct PickYearView: View {
    let challenge: Challenge
    let onAnswer: (String) -> Void

    @State private var selectedYear: Double = 1980
    @State private var hasSubmitted = false

    private let minYear: Double = 1900
    private let maxYear: Double = 2025

    var body: some View {
        VStack(spacing: 24) {
            // Year display
            VStack(spacing: 8) {
                Text("\(Int(selectedYear))")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(.blue)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3), value: selectedYear)

                Text("Selected Year")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 24)

            // Year slider
            VStack(spacing: 16) {
                Slider(
                    value: $selectedYear,
                    in: minYear...maxYear,
                    step: 1
                )
                .tint(.blue)
                .disabled(hasSubmitted)

                // Year markers
                HStack {
                    Text("\(Int(minYear))")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("1950")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("2000")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(Int(maxYear))")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 4)

            // Quick select buttons
            VStack(spacing: 12) {
                Text("Quick Select")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    ForEach([1940, 1960, 1980, 2000, 2020], id: \.self) { year in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedYear = Double(year)
                            }
                            HapticManager.shared.light()
                        }) {
                            Text("\(year)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Int(selectedYear) == year ? .white : DesignSystem.Colors.primaryButton)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(DepthButtonStyle(
                            fill: Int(selectedYear) == year
                                ? DesignSystem.Colors.primaryButton
                                : DesignSystem.Colors.primaryButton.opacity(0.2),
                            base: Int(selectedYear) == year
                                ? DesignSystem.Colors.buttonDepthBase
                                : DesignSystem.Colors.buttonDepthBase.opacity(0.2),
                            cornerRadius: 8,
                            depth: 2,
                            pressedDepth: 1,
                            shadowRadius: 0
                        ))
                        .disabled(hasSubmitted)
                    }
                }
            }

            // Submit button
            Button(action: {
                hasSubmitted = true
                HapticManager.shared.medium()
                onAnswer(String(Int(selectedYear)))
            }) {
                Text("Submit Answer")
                    .depthButtonLabel(font: .system(size: 18, weight: .semibold), verticalPadding: 16)
            }
            .buttonStyle(DepthButtonStyle(cornerRadius: 12))
            .disabled(hasSubmitted)
            .opacity(hasSubmitted ? 0.6 : 1.0)
        }
    }
}

#Preview {
    let challenge = Challenge(
        questionText: "In what year was Citizen Kane released?",
        questionType: .pickYear,
        correctAnswer: "1941",
        wrongAnswers: nil,
        explanation: "Citizen Kane was released in 1941.",
        difficulty: .medium
    )

    return PickYearView(challenge: challenge) { answer in
        print("Selected: \(answer)")
    }
    .padding()
}
