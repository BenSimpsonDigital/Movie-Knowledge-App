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
    let onTap: () -> Void
    let onContinue: () -> Void

    @State private var iconOffset: CGFloat = 0
    @State private var iconScale: CGFloat = 1.0
    @State private var textOffset: CGFloat = -20
    @State private var showButton: Bool = false

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
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                .strokeBorder(
                    isExpanded ? category.accentColor.opacity(0.5) : DesignSystem.Colors.borderDefault,
                    lineWidth: isExpanded ? DesignSystem.Effects.borderWidthSelected : DesignSystem.Effects.borderWidth
                )
        )
        .shadow(
            color: Color.black.opacity(0.04),
            radius: 8,
            x: 0,
            y: 4
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }

    // MARK: - Collapsed Content

    private var collapsedContent: some View {
        HStack(spacing: 16) {
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                category.accentColor.opacity(0.25),
                                category.accentColor.opacity(0.15)
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

            // Title
            Text(category.title)
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .lineLimit(1)

            Spacer()

            // Mini progress indicator
            if progress > 0 {
                miniProgressRing
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }

    // MARK: - Expanded Content

    private var expandedContent: some View {
        VStack(spacing: 16) {
            // Banner area with icon
            ZStack {
                // Light background fill for the banner area
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(category.accentColor.opacity(0.08))
                    .frame(height: 120)

                // Icon container
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    category.accentColor.opacity(0.3),
                                    category.accentColor.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)

                    Image(iconAssetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(category.accentColor)
                }
                .scaleEffect(iconScale)
                .offset(x: iconOffset)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // Text content slides down into place
            VStack(spacing: 12) {
                // Lesson count
                Text("\(category.subCategories.count) \(category.subCategories.count == 1 ? "Lesson" : "Lessons")")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundStyle(category.accentColor)
 
                // Title
                Text(category.title)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                // Subtitle
                Text(category.subtitle)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 20)
            }
            .offset(y: textOffset)
            .opacity(textOffset == 0 ? 1 : 0.7)

            // Continue button
            if showButton {
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(DesignSystem.Colors.primaryButton)
                        )
                }
                .padding(.horizontal, 20)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .padding(.bottom, 24)
        .onAppear {
            // Reset state immediately
            iconOffset = -60
            iconScale = 0.9
            textOffset = -20
            showButton = false

            // Icon slides in from left with spring bounce (one-time)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                iconOffset = 0
                iconScale = 1.0
            }
            // Text slides down into place
            withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                textOffset = 0
            }
            // Button slides in after a short delay
            withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
                showButton = true
            }
        }
        .onDisappear {
            iconOffset = 0
            iconScale = 1.0
            textOffset = -20
            showButton = false
        }
    }

    // MARK: - Helper Views

    private var miniProgressRing: some View {
        ZStack {
            Circle()
                .stroke(DesignSystem.Colors.borderDefault, lineWidth: 2.5)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(category.accentColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .rotationEffect(.degrees(-90))

            Text("\(Int(progress * 100))")
                .font(.system(size: 9, weight: .bold, design: .default))
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .frame(width: 28, height: 28)
    }
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
                onTap: {},
                onContinue: {}
            )

            ExpandableCategoryTile(
                category: category2,
                progress: 0.3,
                isExpanded: false,
                onTap: {},
                onContinue: {}
            )

            ExpandableCategoryTile(
                category: category1,
                progress: 0.0,
                isExpanded: false,
                onTap: {},
                onContinue: {}
            )
        }
        .padding(24)
    }
    .background(DesignSystem.Colors.screenBackground)
    .modelContainer(for: [CategoryModel.self])
}
