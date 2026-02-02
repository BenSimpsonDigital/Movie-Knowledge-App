//
//  InterestPickerView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct InterestPickerView: View {
    @Binding var selectedInterests: Set<String>
    var onContinue: () -> Void

    @State private var showContent = false

    // Available interests grouped by category
    private let interestGroups: [(title: String, interests: [Interest])] = [
        ("Genres", [
            Interest(id: "classic", label: "Classic Cinema", icon: "film.stack"),
            Interest(id: "scifi", label: "Sci-Fi", icon: "sparkles"),
            Interest(id: "horror", label: "Horror", icon: "moon.stars"),
            Interest(id: "animation", label: "Animation", icon: "star.fill"),
            Interest(id: "action", label: "Action", icon: "bolt.fill"),
            Interest(id: "comedy", label: "Comedy", icon: "face.smiling"),
            Interest(id: "drama", label: "Drama", icon: "theatermasks"),
            Interest(id: "documentary", label: "Documentary", icon: "doc.text")
        ]),
        ("Eras", [
            Interest(id: "golden_age", label: "Golden Age (1930-1960)", icon: "crown"),
            Interest(id: "new_hollywood", label: "New Hollywood (1960-1980)", icon: "camera.fill"),
            Interest(id: "80s", label: "1980s", icon: "tv"),
            Interest(id: "90s", label: "1990s", icon: "ticket"),
            Interest(id: "modern", label: "Modern Era (2000+)", icon: "play.rectangle")
        ]),
        ("Movements", [
            Interest(id: "french_new_wave", label: "French New Wave", icon: "globe.europe.africa"),
            Interest(id: "film_noir", label: "Film Noir", icon: "moon.fill"),
            Interest(id: "italian_neorealism", label: "Italian Neorealism", icon: "globe.europe.africa"),
            Interest(id: "german_expressionism", label: "German Expressionism", icon: "paintbrush")
        ]),
        ("Topics", [
            Interest(id: "directors", label: "Famous Directors", icon: "person.fill"),
            Interest(id: "actors", label: "Iconic Actors", icon: "star"),
            Interest(id: "oscars", label: "Academy Awards", icon: "trophy"),
            Interest(id: "behind_scenes", label: "Behind the Scenes", icon: "gearshape")
        ])
    ]

    private var canContinue: Bool {
        selectedInterests.count >= 3
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text("What interests you?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Pick at least 3 topics to personalize your experience")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 20)
            .opacity(showContent ? 1.0 : 0.0)

            // Interest grid
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(interestGroups, id: \.title) { group in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(group.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 24)

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12)
                                ],
                                spacing: 12
                            ) {
                                ForEach(group.interests) { interest in
                                    InterestChip(
                                        interest: interest,
                                        isSelected: selectedInterests.contains(interest.id)
                                    ) {
                                        toggleInterest(interest.id)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
                .padding(.bottom, 120)
            }
            .opacity(showContent ? 1.0 : 0.0)

            // Bottom CTA
            VStack(spacing: 8) {
                Text("\(selectedInterests.count) selected")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(canContinue ? DesignSystem.Colors.primaryButton : .secondary)

                Button(action: {
                    HapticManager.shared.medium()
                    onContinue()
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(canContinue ? DesignSystem.Colors.primaryButton : DesignSystem.Colors.disabled)
                        )
                }
                .disabled(!canContinue)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .background(
                LinearGradient(
                    colors: [
                        DesignSystem.Colors.screenBackground.opacity(0),
                        DesignSystem.Colors.screenBackground
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
                .offset(y: -60),
                alignment: .top
            )
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    private func toggleInterest(_ id: String) {
        HapticManager.shared.light()
        if selectedInterests.contains(id) {
            selectedInterests.remove(id)
        } else {
            selectedInterests.insert(id)
        }
    }
}

// MARK: - Interest Model

struct Interest: Identifiable {
    let id: String
    let label: String
    let icon: String
}

// MARK: - Interest Chip Component

struct InterestChip: View {
    let interest: Interest
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: interest.icon)
                    .font(.system(size: 14))

                Text(interest.label)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .foregroundStyle(isSelected ? .white : .primary)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? DesignSystem.Colors.primaryButton : DesignSystem.Colors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? DesignSystem.Colors.primaryButton : DesignSystem.Colors.borderDefault, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    InterestPickerView(
        selectedInterests: .constant(["classic", "scifi", "directors"]),
        onContinue: {}
    )
}
