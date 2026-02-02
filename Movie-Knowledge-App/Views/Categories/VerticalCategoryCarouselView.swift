//
//  VerticalCategoryCarouselView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

struct VerticalCategoryCarouselView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    @Query(sort: \CategoryModel.displayOrder) private var categories: [CategoryModel]

    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0

    private let cardHeight: CGFloat = 420
    private let cardSpacing: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height

            ZStack {
                // Background
                DesignSystem.Colors.screenBackground
                    .ignoresSafeArea()

                // Cards stack
                ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                    CategoryCarouselCard(
                        category: category,
                        progress: getCategoryProgress(for: category),
                        isActive: index == currentIndex,
                        onStart: {
                            selectCategory(category)
                        }
                    )
                    .frame(height: cardHeight)
                    .padding(.horizontal, 24)
                    .offset(y: calculateOffset(for: index, screenHeight: screenHeight))
                    .scaleEffect(calculateScale(for: index))
                    .opacity(calculateOpacity(for: index))
                    .zIndex(index == currentIndex ? 1 : 0)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.height
                    }
                    .onEnded { value in
                        handleDragEnd(value: value)
                    }
            )
        }
    }

    // MARK: - Calculations

    private func calculateOffset(for index: Int, screenHeight: CGFloat) -> CGFloat {
        let baseOffset = CGFloat(index - currentIndex) * (cardHeight + cardSpacing)
        let centerOffset = (screenHeight - cardHeight) / 2 - 60 // Adjust for nav bar
        return baseOffset + dragOffset + centerOffset
    }

    private func calculateScale(for index: Int) -> CGFloat {
        let distance = abs(index - currentIndex)
        if distance == 0 {
            // Current card - scale based on drag
            let dragScale = 1.0 - abs(dragOffset) / 1500
            return max(0.95, min(1.0, dragScale))
        } else if distance == 1 {
            return 0.92
        } else {
            return 0.85
        }
    }

    private func calculateOpacity(for index: Int) -> Double {
        let distance = abs(index - currentIndex)
        if distance == 0 {
            return 1.0
        } else if distance == 1 {
            return 0.6
        } else if distance == 2 {
            return 0.3
        } else {
            return 0
        }
    }

    // MARK: - Gesture Handling

    private func handleDragEnd(value: DragGesture.Value) {
        let threshold: CGFloat = 100
        let velocity = value.predictedEndTranslation.height - value.translation.height

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if value.translation.height < -threshold || velocity < -300 {
                // Swipe up - next category
                if currentIndex < categories.count - 1 {
                    currentIndex += 1
                    HapticManager.shared.medium()
                }
            } else if value.translation.height > threshold || velocity > 300 {
                // Swipe down - previous category
                if currentIndex > 0 {
                    currentIndex -= 1
                    HapticManager.shared.medium()
                }
            }
            dragOffset = 0
        }
    }

    // MARK: - Data

    private func getCategoryProgress(for category: CategoryModel) -> Double {
        guard let profile = appState.userProfile else { return 0 }

        if let progress = profile.categoryProgress.first(where: { $0.categoryId == category.id }) {
            let totalSubCategories = category.subCategories.count
            guard totalSubCategories > 0 else { return 0 }
            return Double(progress.completedCount) / Double(totalSubCategories)
        }
        return 0
    }

    private func selectCategory(_ category: CategoryModel) {
        HapticManager.shared.medium()
        appState.activeCategory = category
    }
}

// MARK: - Category Carousel Card

struct CategoryCarouselCard: View {
    let category: CategoryModel
    let progress: Double
    let isActive: Bool
    let onStart: () -> Void

    @Environment(AppState.self) private var appState

    private var difficultyLevel: String {
        if progress == 0 {
            return "Beginner"
        } else if progress < 0.5 {
            return "Intermediate"
        } else if progress < 1.0 {
            return "Advanced"
        } else {
            return "Mastered"
        }
    }

    private var difficultyColor: Color {
        switch difficultyLevel {
        case "Beginner":
            return .green
        case "Intermediate":
            return .blue
        case "Advanced":
            return .orange
        case "Mastered":
            return .purple
        default:
            return .gray
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header with icon and difficulty
            HStack {
                // Difficulty badge
                Text(difficultyLevel.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.5)
                    .foregroundStyle(difficultyColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(difficultyColor.opacity(0.15))
                    .clipShape(Capsule())

                Spacer()

                // Progress ring
                ZStack {
                    Circle()
                        .stroke(DesignSystem.Colors.borderDefault, lineWidth: 4)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(category.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(category.accentColor)
                }
                .frame(width: 44, height: 44)
            }

            Spacer()

            // Center content - Icon and title
            VStack(spacing: 16) {
                // Category icon
                Image(systemName: category.iconName ?? "film")
                    .font(.system(size: 50))
                    .foregroundStyle(category.accentColor)
                    .frame(width: 90, height: 90)
                    .background(category.accentColor.opacity(0.15))
                    .clipShape(Circle())

                // Title
                Text(category.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                // Subtitle
                Text(category.subtitle)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }

            Spacer()

            // Progress bar
            VStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(DesignSystem.Colors.borderDefault)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(category.accentColor)
                            .frame(width: geometry.size.width * progress)
                    }
                }
                .frame(height: 8)

                HStack {
                    Text("\(category.subCategories.count) lessons")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Spacer()

                    if let tag = category.tag {
                        Text(tag)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(DesignSystem.Colors.tagText)
                    }
                }
            }

            // CTA Button
            Button(action: onStart) {
                HStack(spacing: 8) {
                    Image(systemName: progress > 0 ? "play.fill" : "play.circle.fill")
                        .font(.system(size: 16))

                    Text(progress > 0 ? "Continue" : "Start Learning")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(DesignSystem.Colors.primaryButton)
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(DesignSystem.Colors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    isActive ? DesignSystem.Colors.borderSelected : Color.clear,
                    lineWidth: isActive ? DesignSystem.Effects.borderWidthSelected : 0
                )
        )
        .shadow(
            color: Color.black.opacity(isActive ? 0.12 : 0.06),
            radius: isActive ? 24 : 16,
            y: isActive ? 12 : 8
        )
    }
}

#Preview {
    VerticalCategoryCarouselView()
        .environment(AppState())
}
