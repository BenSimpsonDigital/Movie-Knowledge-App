//
//  ContinueOnTile.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct ContinueOnTile: View {
    let category: CategoryModel?
    let isLastPlayed: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    private var labelText: String {
        isLastPlayed ? "Continue On" : "Start Here"
    }
    
    private var subtitleText: String {
        isLastPlayed ? "Pick up where you left off" : "Recommended for you"
    }
    
    var body: some View {
        Button(action: {
            HapticManager.shared.medium()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Top label
                Text(labelText.uppercased())
                    .font(.system(size: 11, weight: .semibold, design: .default))
                    .foregroundStyle(category?.accentColor ?? DesignSystem.Colors.accent)
                    .tracking(0.5)
                
                Spacer()
                
                // Category title
                Text(category?.title ?? "Get Started")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Subtitle
                Text(subtitleText)
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)
                
                // Arrow indicator
                HStack {
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(category?.accentColor ?? DesignSystem.Colors.accent)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 140)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
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
        title: "Core Film Knowledge",
        subtitle: "Essential movie fundamentals",
        tag: "START",
        iconName: "film.stack",
        colorRed: 0.75,
        colorGreen: 0.68,
        colorBlue: 0.58,
        displayOrder: 0
    )
    
    HStack(spacing: 12) {
        ContinueOnTile(
            category: category,
            isLastPlayed: true,
            onTap: {}
        )
        
        ContinueOnTile(
            category: category,
            isLastPlayed: false,
            onTap: {}
        )
    }
    .padding(24)
    .background(DesignSystem.Colors.screenBackground)
}
