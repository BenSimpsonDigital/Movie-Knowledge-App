//
//  FeaturedCategoryTile.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct FeaturedCategoryTile: View {
    let category: CategoryModel
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    private var categoryDifficulty: String {
        let allChallenges = category.subCategories.flatMap { $0.challenges }
        guard !allChallenges.isEmpty else { return "Medium" }
        
        let difficulties = allChallenges.map { $0.difficulty }
        let easyCount = difficulties.filter { $0 == .easy }.count
        let mediumCount = difficulties.filter { $0 == .medium }.count
        let hardCount = difficulties.filter { $0 == .hard }.count
        
        if hardCount > easyCount && hardCount > mediumCount {
            return "Hard"
        } else if easyCount > mediumCount && easyCount > hardCount {
            return "Easy"
        } else {
            return "Medium"
        }
    }
    
    var body: some View {
        Button(action: {
            HapticManager.shared.medium()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Top label with difficulty badge
                HStack {
                    Text("TODAY'S PICK")
                        .font(.system(size: 11, weight: .bold, design: .default))
                        .foregroundStyle(category.accentColor)
                        .tracking(0.6)
                    
                    Spacer()
                    
                    // Difficulty badge
                    Text(categoryDifficulty.uppercased())
                        .font(.system(size: 10, weight: .bold, design: .default))
                        .foregroundStyle(category.accentColor)
                        .tracking(0.5)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(category.accentColor.opacity(0.15))
                        .clipShape(Capsule())
                }
                .padding(.bottom, 10)
                
                Spacer(minLength: 8)
                
                // Category title
                Text(category.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 6)
                
                // Subtitle
                Text(category.subtitle)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
                    .padding(.bottom, 10)
                
                // Arrow indicator
                HStack {
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(category.accentColor)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 140)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault.opacity(0.5), lineWidth: DesignSystem.Effects.borderWidth)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(DesignSystem.Animations.snappy, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    let category = CategoryModel(
        title: "Behind the Scenes",
        subtitle: "The art and technique of filmmaking",
        tag: "CRAFT",
        iconName: "video",
        colorRed: 0.20,
        colorGreen: 0.70,
        colorBlue: 0.45,
        displayOrder: 6
    )
    
    VStack {
        HStack(spacing: 12) {
            FeaturedCategoryTile(
                category: category,
                onTap: {}
            )
            
            // Simulate the Director tile to show real layout
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 140)
        }
        .padding(24)
        
        Spacer()
    }
    .background(DesignSystem.Colors.screenBackground)
}
