//
//  DesignSystem.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean design system
//

import SwiftUI

/// Centralized design system constants for consistent styling across the app
enum DesignSystem {

    // MARK: - Colors
    enum Colors {
        // MARK: Backgrounds
        /// Neutral off-white screen background
        static let screenBackground = Color(red: 0.98, green: 0.98, blue: 0.98)

        /// Pure white for cards
        static let cardBackground = Color.white

        /// Subtle gray for secondary surfaces
        static let surfaceSecondary = Color(red: 0.94, green: 0.94, blue: 0.93)

        // MARK: Text (3-level hierarchy)
        /// Near black for primary text
        static let textPrimary = Color(red: 0.12, green: 0.12, blue: 0.13)

        /// Medium gray for secondary text
        static let textSecondary = Color(red: 0.50, green: 0.50, blue: 0.52)

        /// Light gray for tertiary text
        static let textTertiary = Color(red: 0.70, green: 0.70, blue: 0.72)

        // MARK: Accent
        /// Muted teal accent for primary actions
        static let accent = Color(red: 0.35, green: 0.55, blue: 0.50)

        /// Blue-purple accent for tab bar selection
        static let tabAccent = Color(red: 0.36, green: 0.37, blue: 0.91)

        /// Primary button color (matches tab accent purple)
        static let primaryButton = tabAccent

        /// Light accent for backgrounds
        static let accentLight = Color(red: 0.92, green: 0.95, blue: 0.94)

        /// Compatibility alias
        static let primaryAction = accent

        // MARK: Borders
        /// Light border for card definition
        static let borderDefault = Color(red: 0.90, green: 0.90, blue: 0.89)

        /// Accent border for selection
        static let borderSelected = accent

        /// Subtle hover state
        static let borderHover = Color(red: 0.85, green: 0.85, blue: 0.84)

        // MARK: Interactive States
        /// Selected item background
        static let selectedBackground = accentLight

        /// Pressed state background
        static let pressedBackground = Color(red: 0.90, green: 0.93, blue: 0.92)

        /// Disabled state
        static let disabled = Color(red: 0.80, green: 0.80, blue: 0.80)

        // MARK: Tags
        /// Tag background
        static let tagBackground = surfaceSecondary

        /// Tag text
        static let tagText = textSecondary

        // MARK: Category Accents (Muted Palette)
        enum CategoryAccents {
            static let classicCinema = Color(red: 0.75, green: 0.68, blue: 0.58)      // Warm taupe
            static let sciFi = Color(red: 0.55, green: 0.65, blue: 0.72)              // Soft steel
            static let romanticComedies = Color(red: 0.78, green: 0.65, blue: 0.68)  // Dusty rose
            static let actionThrillers = Color(red: 0.72, green: 0.65, blue: 0.60)   // Warm stone
            static let horrorNights = Color(red: 0.60, green: 0.58, blue: 0.68)      // Muted lavender
            static let documentaries = Color(red: 0.58, green: 0.68, blue: 0.62)     // Sage
            static let animatedAdventures = Color(red: 0.80, green: 0.76, blue: 0.62) // Soft gold
            static let foreignFilms = Color(red: 0.72, green: 0.62, blue: 0.60)      // Terracotta
            static let filmNoir = Color(red: 0.48, green: 0.48, blue: 0.50)          // Charcoal
            static let superheroSagas = Color(red: 0.58, green: 0.65, blue: 0.75)    // Steel blue
            static let comingOfAge = Color(red: 0.78, green: 0.72, blue: 0.65)       // Warm sand
            static let crimeDramas = Color(red: 0.68, green: 0.55, blue: 0.55)       // Muted burgundy
        }

        // MARK: Semantic Colors (Subtle)
        /// Success - muted green
        static let successGreen = Color(red: 0.45, green: 0.65, blue: 0.50)
        static let successGreenLight = Color(red: 0.92, green: 0.96, blue: 0.93)

        /// Error - muted red
        static let errorRed = Color(red: 0.75, green: 0.45, blue: 0.45)
        static let errorRedLight = Color(red: 0.97, green: 0.93, blue: 0.93)

        /// Warning - muted amber
        static let warningOrange = Color(red: 0.78, green: 0.65, blue: 0.45)
        static let warningOrangeLight = Color(red: 0.97, green: 0.95, blue: 0.92)

        // MARK: Legacy Compatibility
        /// Gold accent (now uses accent for minimal design)
        static let goldAccent = accent
        static let goldAccentLight = accentLight
        static let xpGold = textSecondary
        static let xpGoldLight = surfaceSecondary
    }

    // MARK: - Typography
    enum Typography {
        /// Body font - clean and readable sans-serif
        static let bodyFont = Font.system(.body, design: .default)

        /// Icon sizes
        static let iconSize: CGFloat = 44
        static let iconSizeLarge: CGFloat = 44
        static let iconSizeMedium: CGFloat = 28
        static let iconSizeSmall: CGFloat = 20

        /// Display: 32pt Bold
        static let displaySize: CGFloat = 32

        /// Title: 28pt Bold
        static let titleSize: CGFloat = 28
        static let titleWeight: Font.Weight = .bold

        /// Large title: 24pt Bold
        static let largeTitleSize: CGFloat = 24
        static let largeTitleWeight: Font.Weight = .bold

        /// Heading: 20pt Semibold
        static let headingSize: CGFloat = 20
        static let headingWeight: Font.Weight = .semibold

        /// Subtitle: 17pt Regular
        static let subtitleSize: CGFloat = 17
        static let subtitleWeight: Font.Weight = .regular

        /// Body: 15pt Regular
        static let bodySize: CGFloat = 15
        static let bodyWeight: Font.Weight = .regular

        /// Caption: 13pt Medium
        static let captionSize: CGFloat = 13
        static let captionWeight: Font.Weight = .medium

        /// Tag: 11pt Medium
        static let tagSize: CGFloat = 11
        static let tagWeight: Font.Weight = .medium
        static let tagTracking: CGFloat = 0.5

        // MARK: - Font Helpers
        static func display(_ size: CGFloat = displaySize) -> Font {
            .system(size: size, weight: .bold, design: .default)
        }

        static func title(_ weight: Font.Weight = .bold) -> Font {
            .system(size: titleSize, weight: weight, design: .default)
        }

        static func heading(_ weight: Font.Weight = .semibold) -> Font {
            .system(size: headingSize, weight: weight, design: .default)
        }

        static func body(_ weight: Font.Weight = .regular) -> Font {
            .system(size: bodySize, weight: weight, design: .default)
        }

        static func caption(_ weight: Font.Weight = .medium) -> Font {
            .system(size: captionSize, weight: weight, design: .default)
        }
    }

    // MARK: - Spacing
    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40

        // Compatibility
        static let tightSpacing: CGFloat = 8
        static let itemSpacing: CGFloat = 16
        static let cardSpacing: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let screenHorizontalMargin: CGFloat = 20
        static let cardPadding: CGFloat = 24
        static let tagHorizontalPadding: CGFloat = 12
        static let tagVerticalPadding: CGFloat = 6
        static let screenMargin: CGFloat = 20
    }

    // MARK: - Dimensions
    enum Dimensions {
        /// Card heights
        static let cardHeight: CGFloat = 400
        static let cardHeightLarge: CGFloat = 180
        static let cardHeightMedium: CGFloat = 140
        static let cardHeightSmall: CGFloat = 100

        /// Tile dimensions
        static let tileHeight: CGFloat = 160
        static let tileIconSize: CGFloat = 40

        /// Progress indicators
        static let progressRingSize: CGFloat = 44
        static let progressRingLineWidth: CGFloat = 2
        static let progressRingSizeLarge: CGFloat = 56
        static let progressRingSizeMedium: CGFloat = 44
        static let progressRingSizeSmall: CGFloat = 28
        static let progressBarHeight: CGFloat = 4

        /// Button heights
        static let primaryButtonHeight: CGFloat = 50
        static let secondaryButtonHeight: CGFloat = 44
        static let buttonHeightLarge: CGFloat = 50
        static let buttonHeightMedium: CGFloat = 44
        static let buttonHeightSmall: CGFloat = 36

        /// Avatar sizes
        static let avatarLarge: CGFloat = 80
        static let avatarMedium: CGFloat = 56
        static let avatarSmall: CGFloat = 40

        /// Tab bar
        static let tabBarHeight: CGFloat = 72
        static let tabIconSize: CGFloat = 22

        /// Safe bottom padding to avoid tab bar overlap
        static let tabSafeBottomPadding: CGFloat = 80
    }

    // MARK: - Visual Effects
    enum Effects {
        // MARK: Single Shadow Level
        /// Subtle shadow for modern depth
        static let shadowColor = Color.black.opacity(0.06)
        static let shadowRadius: CGFloat = 10
        static let shadowYOffset: CGFloat = 4

        // Compatibility aliases
        static let shadowElevatedColor = shadowColor
        static let shadowElevatedRadius = shadowRadius
        static let shadowElevatedY = shadowYOffset
        static let shadowSubtleColor = shadowColor
        static let shadowSubtleRadius = shadowRadius
        static let shadowSubtleY = shadowYOffset
        static let shadowFloatingColor = Color.black.opacity(0.06)
        static let shadowFloatingRadius: CGFloat = 8
        static let shadowFloatingY: CGFloat = 4

        // MARK: Borders
        static let borderWidth: CGFloat = 1.0
        static let borderWidthSelected: CGFloat = 1.5
        static let borderWidthThick: CGFloat = 2.0

        // MARK: Corner Radii
        static let radiusSmall: CGFloat = 8
        static let radiusMedium: CGFloat = 16
        static let radiusLarge: CGFloat = 20
        static let radiusXLarge: CGFloat = 20

        // Compatibility
        static let cardCornerRadius: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 10
        static let smallCornerRadius: CGFloat = 6

        // MARK: Blur (Minimal use)
        static let blurLight: CGFloat = 4
        static let blurMedium: CGFloat = 8
        static let blurHeavy: CGFloat = 12

        // Card stack (legacy)
        static let backgroundCardScale: CGFloat = 0.95
        static let backgroundCardOffset: CGFloat = 20
        static let backgroundCardOpacity: Double = 0.5
        static let cardTiltLight: Double = 1.0
        static let cardTiltMedium: Double = 2.0

        // Scale effects (subtle)
        static let scalePressed: CGFloat = 0.98
        static let scaleHover: CGFloat = 1.01
    }

    // MARK: - Interactions
    enum Interactions {
        static let swipeThreshold: CGFloat = 100
        static let velocityThreshold: CGFloat = 500
        static let maxDragDistance: CGFloat = 300

        static let animationDuration: Double = 0.25
        static let animationResponse: Double = 0.3
        static let animationDamping: Double = 0.85

        static func springAnimation(delay: Double = 0) -> Animation {
            .spring(response: animationResponse, dampingFraction: animationDamping)
            .delay(delay)
        }

        static func easeInOut(duration: Double = animationDuration, delay: Double = 0) -> Animation {
            .easeInOut(duration: duration).delay(delay)
        }
    }

    // MARK: - Animations (Subtle)
    enum Animations {
        /// Quick spring - minimal bounce
        static let snappy = Animation.spring(response: 0.25, dampingFraction: 0.85)

        /// Smooth spring - standard interactions
        static let smooth = Animation.spring(response: 0.3, dampingFraction: 0.9)

        /// Gentle spring - subtle transitions
        static let gentle = Animation.spring(response: 0.4, dampingFraction: 0.9)

        /// Compatibility - less bouncy now
        static let bouncy = smooth

        /// Quick ease
        static let quick = Animation.easeOut(duration: 0.15)

        /// Standard ease
        static let standard = Animation.easeInOut(duration: 0.25)

        /// Slow ease
        static let slow = Animation.easeInOut(duration: 0.35)

        static func staggered(index: Int, baseDelay: Double = 0.03) -> Animation {
            smooth.delay(Double(index) * baseDelay)
        }
    }

    // MARK: - XP System
    enum XP {
        static let easyXP: Int = 10
        static let mediumXP: Int = 15
        static let hardXP: Int = 20

        static func xpForLevel(_ level: Int) -> Int {
            return level * 100
        }

        static func levelFromXP(_ xp: Int) -> Int {
            return max(1, xp / 100)
        }
    }

    // MARK: - Badges
    enum BadgeCategories: String, CaseIterable {
        case categoryCompletion = "Category Completion"
        case streakMilestone = "Streak Milestone"
        case xpMilestone = "XP Milestone"
        case accuracy = "Accuracy"
    }
}

// MARK: - View Modifiers

extension View {
    /// Apply minimal card styling with subtle shadow
    func minimalCard() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
            .shadow(
                color: DesignSystem.Effects.shadowColor,
                radius: DesignSystem.Effects.shadowRadius,
                x: 0,
                y: DesignSystem.Effects.shadowYOffset
            )
    }

    /// Apply elevated card styling (minimal shadow for compatibility)
    func elevatedCard() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
            .shadow(
                color: DesignSystem.Effects.shadowColor,
                radius: DesignSystem.Effects.shadowRadius,
                x: 0,
                y: DesignSystem.Effects.shadowYOffset
            )
    }

    /// Apply subtle card styling
    func subtleCard() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
    }

    /// Apply floating card styling with shadow
    func floatingCard() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
            .shadow(
                color: DesignSystem.Effects.shadowFloatingColor,
                radius: DesignSystem.Effects.shadowFloatingRadius,
                x: 0,
                y: DesignSystem.Effects.shadowFloatingY
            )
    }

    /// Apply primary button styling
    func premiumButton() -> some View {
        self
            .font(DesignSystem.Typography.body(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: DesignSystem.Dimensions.buttonHeightLarge)
            .background(DesignSystem.Colors.primaryButton)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
    }

    /// Apply secondary button styling
    func secondaryButton() -> some View {
        self
            .font(DesignSystem.Typography.body(.medium))
            .foregroundStyle(DesignSystem.Colors.accent)
            .frame(maxWidth: .infinity)
            .frame(height: DesignSystem.Dimensions.buttonHeightMedium)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
            )
    }
}
