//
//  DirectorSpotlightTile.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct DirectorSpotlightTile: View {
    let spotlight: DirectorSpotlight?
    let category: CategoryModel?
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.medium()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Top label
                Text("DIRECTOR SPOTLIGHT")
                    .font(.system(size: 11, weight: .bold, design: .default))
                    .foregroundStyle(spotlight?.accentColor ?? DesignSystem.Colors.accent)
                    .tracking(0.6)
                
                Spacer()
                
                // Director name
                Text(spotlight?.directorName ?? "Featured Director")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Tagline
                Text(spotlight?.tagline ?? "Explore their filmography")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textPrimary.opacity(0.75))
                    .lineLimit(1)
                
                // Arrow indicator
                HStack {
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(spotlight?.accentColor ?? DesignSystem.Colors.accent)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 160)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault.opacity(0.5), lineWidth: DesignSystem.Effects.borderWidth)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 4)
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
    let spotlight = DirectorSpotlight(
        directorName: "Wes Anderson",
        tagline: "Symmetry and whimsy",
        accentColorRed: 0.80,
        accentColorGreen: 0.76,
        accentColorBlue: 0.62,
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    )
    
    let category = CategoryModel(
        title: "Directors and Creators",
        subtitle: "Master filmmakers",
        tag: nil,
        iconName: "sparkles",
        colorRed: 0.75,
        colorGreen: 0.68,
        colorBlue: 0.58,
        displayOrder: 1
    )
    
    HStack(spacing: 12) {
        DirectorSpotlightTile(
            spotlight: spotlight,
            category: category,
            onTap: {}
        )
        
        DirectorSpotlightTile(
            spotlight: nil,
            category: nil,
            onTap: {}
        )
    }
    .padding(24)
    .background(DesignSystem.Colors.screenBackground)
}
