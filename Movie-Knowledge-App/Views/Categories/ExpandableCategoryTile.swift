//
//  ExpandableCategoryTile.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 30/1/2026.
//

import SwiftUI
import SwiftData

struct ExpandableCategoryTile: View {
    let category: CategoryModel
    let progress: Double
    let isExpanded: Bool
    let isOtherExpanded: Bool
    let onTap: () -> Void
    let onContinue: () -> Void

    @State private var contentOpacity: CGFloat = 0
    @State private var buttonScale: CGFloat = 0.92
    @State private var buttonOpacity: CGFloat = 0

    // MARK: - Computed Properties
    
    private var buttonText: String {
        progress > 0 ? "Continue Learning" : "Start Learning"
    }
    
    private var difficultyLevel: (label: String, color: Color) {
        // Map categories to difficulty levels
        switch category.title {
        case "Core Film Knowledge", "Genres", "Actors and Performances", "Franchises and Series":
            return ("Easy", Color.green)
        case "Directors and Creators", "World Cinema", "Movie Eras", "Awards and Recognition":
            return ("Intermediate", Color.orange)
        case "Behind the Scenes", "Film Craft and Behind the Scenes":
            return ("Film Nerd", Color.purple)
        default:
            return ("Intermediate", Color.orange)
        }
    }
    
    // MARK: - Icon Name Conversion

    private var iconAssetName: String {
        guard let iconName = category.iconName else {
            return "heroicon-film-outline"
        }

        let baseIconMap: [String: String] = [
            "film.stack": "heroicon-film",
            "sparkles": "heroicon-sparkles",
            "heart.circle": "heroicon-heart",
            "bolt.fill": "heroicon-bolt",
            "moon.stars": "heroicon-moon",
            "doc.text": "heroicon-document-text",
            "star.fill": "heroicon-star",
            "globe": "heroicon-globe-alt",
            "theatermasks": "heroicon-film",
            "bolt.shield": "heroicon-shield-check",
            "figure.walk": "heroicon-user",
            "lock.shield": "heroicon-lock-closed",
            "play.circle": "heroicon-play-circle",
            "bookmark": "heroicon-bookmark",
            "heart": "heroicon-heart",
            "lightbulb": "heroicon-light-bulb",
            "flame": "heroicon-fire",
            "graduationcap": "heroicon-academic-cap",
            "book.open": "heroicon-book-open",
            "trophy": "heroicon-trophy",
            "camera": "heroicon-camera",
            "ticket": "heroicon-ticket"
        ]

        let baseName = baseIconMap[iconName] ?? "heroicon-film"
        return baseName + "-outline"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if isExpanded {
                expandedContent
            } else {
                collapsedContent
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            DesignSystem.Colors.cardBackground
        )
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                .strokeBorder(
                    isExpanded ? category.accentColor.opacity(0.3) : DesignSystem.Colors.borderDefault,
                    lineWidth: isExpanded ? 2 : DesignSystem.Effects.borderWidth
                )
        )
        .shadow(
            color: Color.black.opacity(isExpanded ? 0.08 : 0.04),
            radius: isExpanded ? 12 : 8,
            x: 0,
            y: isExpanded ? 6 : 4
        )
        .opacity(isOtherExpanded ? 0.5 : 1.0)
        .scaleEffect(isOtherExpanded ? 0.97 : 1.0)
        .animation(DesignSystem.Animations.smooth, value: isOtherExpanded)
        .onChange(of: isExpanded) { oldValue, newValue in
            if newValue {
                // Reset state immediately when expanding
                contentOpacity = 0
                buttonScale = 0.92
                buttonOpacity = 0
                
                // Smooth staggered entrance
                withAnimation(.easeOut(duration: 0.35)) {
                    contentOpacity = 1.0
                }
                
                // Button slides up and fades in smoothly
                withAnimation(.spring(response: 0.45, dampingFraction: 0.82).delay(0.18)) {
                    buttonScale = 1.0
                    buttonOpacity = 1.0
                }
            } else {
                // Quick fade out when collapsing
                withAnimation(.easeOut(duration: 0.15)) {
                    contentOpacity = 0
                    buttonOpacity = 0
                    buttonScale = 0.92
                }
            }
        }
    }

    // MARK: - Collapsed Content

    private var collapsedContent: some View {
        HStack(spacing: 16) {
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                category.accentColor.opacity(0.25),
                                category.accentColor.opacity(0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)

                Image(iconAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(category.accentColor)
            }

            // Title and Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(category.journeySubtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Text("\(category.subCategories.count) lessons")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(DesignSystem.Colors.surfaceSecondary)
                .clipShape(Capsule())
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 22)
        .frame(minHeight: 96)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }

    // MARK: - Expanded Content

    private var expandedContent: some View {
        VStack(spacing: 0) {
            // Header Section
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    // Icon container with gradient
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        category.accentColor.opacity(0.2),
                                        category.accentColor.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)

                        Image(iconAssetName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .foregroundStyle(category.accentColor)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(category.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(category.subtitle)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 8)
                }
                
                // Stats row
                HStack(spacing: 12) {
                    // Lessons count badge
                    HStack(spacing: 6) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                        
                        Text("\(category.subCategories.count) \(category.subCategories.count == 1 ? "Lesson" : "Lessons")")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(DesignSystem.Colors.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    // Difficulty badge
                    HStack(spacing: 6) {
                        Image(systemName: "gauge.with.dots.needle.33percent")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(difficultyLevel.color)
                        
                        Text(difficultyLevel.label)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(difficultyLevel.color)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(difficultyLevel.color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    if progress > 0 {
                        // Progress badge
                        HStack(spacing: 6) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(category.accentColor)
                            
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(category.accentColor)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(category.accentColor.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }

                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 20)
            .opacity(contentOpacity)
            
            // Divider
            Rectangle()
                .fill(DesignSystem.Colors.borderDefault)
                .frame(height: 1)
                .padding(.horizontal, 24)
                .opacity(contentOpacity)
            
            // What you'll learn section
            VStack(alignment: .leading, spacing: 16) {
                Text("What you'll learn")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(categoryHighlights(for: category.title).prefix(3), id: \.self) { highlight in
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(category.accentColor.opacity(0.15))
                                    .frame(width: 20, height: 20)
                                
                                Circle()
                                    .fill(category.accentColor)
                                    .frame(width: 6, height: 6)
                            }
                            .padding(.top, 2)

                            Text(highlight)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(contentOpacity)

            // CTA Button
            Button(action: onContinue) {
                HStack(spacing: 8) {
                    Text(buttonText)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [
                            DesignSystem.Colors.textPrimary,
                            DesignSystem.Colors.textPrimary.opacity(0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .scaleEffect(buttonScale)
            .opacity(buttonOpacity)
        }
    }

    // MARK: - Helper Functions
    
    private func categoryHighlights(for title: String) -> [String] {
        switch title {
        case "Core Film Knowledge":
            return [
                "Film history and milestones",
                "Iconic movie quotes",
                "Box office records"
            ]
        case "Directors and Creators":
            return [
                "Legendary filmmakers",
                "Signature directing styles",
                "Indie cinema pioneers"
            ]
        case "Genres":
            return [
                "Action, drama, comedy & more",
                "Genre conventions",
                "Crossover masterpieces"
            ]
        case "World Cinema":
            return [
                "International classics",
                "Cultural storytelling",
                "Award-winning foreign films"
            ]
        case "Awards and Recognition":
            return [
                "Oscar history & records",
                "Cannes & festival winners",
                "Critics' choice selections"
            ]
        case "Behind the Scenes":
            return [
                "Cinematography techniques",
                "Special effects mastery",
                "Screenwriting essentials"
            ]
        case "Movie Eras":
            return [
                "Silent era to modern day",
                "Golden age classics",
                "Contemporary cinema"
            ]
        case "Actors and Performances":
            return [
                "Iconic performances",
                "Method acting legends",
                "On-screen chemistry"
            ]
        case "Franchises and Series":
            return [
                "Star Wars to Marvel",
                "Trilogy masterclasses",
                "Cinematic universes"
            ]
        default:
            return [
                "Engaging lessons",
                "Fascinating trivia",
                "Test your knowledge"
            ]
        }
    }

    // MARK: - Helper Views
}

// MARK: - Preview

#Preview {
    let category1 = CategoryModel(
        title: "Classic Cinema",
        subtitle: "Timeless masterpieces from the golden age of film",
        tag: "TOP PICK",
        iconName: "film.stack",
        colorRed: 0.75,
        colorGreen: 0.60,
        colorBlue: 0.45,
        displayOrder: 0
    )

    let category2 = CategoryModel(
        title: "Sci-Fi Spectacles",
        subtitle: "Journey through space and time",
        tag: nil,
        iconName: "sparkles",
        colorRed: 0.40,
        colorGreen: 0.55,
        colorBlue: 0.75,
        displayOrder: 1
    )

    ScrollView {
        VStack(spacing: 16) {
            ExpandableCategoryTile(
                category: category1,
                progress: 0.65,
                isExpanded: true,
                isOtherExpanded: false,
                onTap: {},
                onContinue: {}
            )

            ExpandableCategoryTile(
                category: category2,
                progress: 0.3,
                isExpanded: false,
                isOtherExpanded: true,
                onTap: {},
                onContinue: {}
            )

            ExpandableCategoryTile(
                category: category1,
                progress: 0.0,
                isExpanded: false,
                isOtherExpanded: true,
                onTap: {},
                onContinue: {}
            )
        }
        .padding(24)
    }
    .background(DesignSystem.Colors.screenBackground)
    .modelContainer(for: [CategoryModel.self])
}
