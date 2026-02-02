# Movie Knowledge App - Visual Style Guide

## Overview

This guide documents the minimal, clean design system for the Movie Knowledge App. The design prioritizes calm, intentional interfaces over gamified chaos - easy to scan, easy on the eyes.

---

## Design Philosophy

**Core Principles:**
- Clean, minimal, modern
- Flat or lightly shaded icons
- Limited color palettes (one color per category)
- Reduced glow, gradients, and visual noise
- Calm and intentional feel

---

## Color Palette

### Background Colors
- **Screen Background**: Neutral off-white `Color(red: 0.98, green: 0.98, blue: 0.98)` or `rgb(250, 250, 250)`
- **Card Background**: Pure white `Color.white`
- **Surface Secondary**: Subtle gray `Color(red: 0.94, green: 0.94, blue: 0.93)`

### Text Colors (3-Level Hierarchy)
| Level | RGB Values | Usage |
|-------|-----------|-------|
| Primary | `(0.12, 0.12, 0.13)` | Headings, important text |
| Secondary | `(0.50, 0.50, 0.52)` | Body text, labels |
| Tertiary | `(0.70, 0.70, 0.72)` | Captions, hints |

### Accent Color
- **Primary Accent**: Muted teal `Color(red: 0.35, green: 0.55, blue: 0.50)` - used for buttons, selections
- **Accent Light**: `Color(red: 0.92, green: 0.95, blue: 0.94)` - used for backgrounds

### Border Colors
- **Default**: `Color(red: 0.90, green: 0.90, blue: 0.89)` - 1pt stroke on cards
- **Selected**: Accent color - 1.5pt stroke when selected

### Category Accent Colors (Muted Palette)

| Category | RGB Values | Description |
|----------|-----------|-------------|
| Classic Cinema | `(0.75, 0.68, 0.58)` | Warm taupe |
| Sci-Fi Spectacles | `(0.55, 0.65, 0.72)` | Soft steel |
| Romantic Comedies | `(0.78, 0.65, 0.68)` | Dusty rose |
| Action Thrillers | `(0.72, 0.65, 0.60)` | Warm stone |
| Horror Nights | `(0.60, 0.58, 0.68)` | Muted lavender |
| Documentaries | `(0.58, 0.68, 0.62)` | Sage |
| Animated Adventures | `(0.80, 0.76, 0.62)` | Soft gold |
| Foreign Films | `(0.72, 0.62, 0.60)` | Terracotta |
| Film Noir | `(0.48, 0.48, 0.50)` | Charcoal |
| Superhero Sagas | `(0.58, 0.65, 0.75)` | Steel blue |
| Coming of Age | `(0.78, 0.72, 0.65)` | Warm sand |
| Crime Dramas | `(0.68, 0.55, 0.55)` | Muted burgundy |

### Semantic Colors (Subtle)
| State | Color | Usage |
|-------|-------|-------|
| Success | `(0.45, 0.65, 0.50)` | Correct answers |
| Error | `(0.75, 0.45, 0.45)` | Incorrect answers |
| Warning | `(0.78, 0.65, 0.45)` | Caution states |

---

## Typography

### Font System
- **Font Family**: System font with `.default` design (SF Pro)
- **Design**: Clean, modern, professional

### Type Scale
| Element | Size | Weight |
|---------|------|--------|
| Display | 32pt | Bold |
| Title | 28pt | Bold |
| Large Title | 24pt | Bold |
| Heading | 20pt | Semibold |
| Body | 15pt | Regular |
| Caption | 13pt | Medium |
| Tag | 11pt | Medium (0.5 tracking) |

### Usage Guidelines
- Headings: Primary text color
- Body: Secondary text color
- Labels/captions: Tertiary text color
- Use uppercase + tracking for small labels

---

## Spacing

| Token | Value | Usage |
|-------|-------|-------|
| xxs | 4pt | Tight gaps |
| xs | 8pt | Small spacing |
| sm | 12pt | Component gaps |
| md | 16pt | Standard spacing |
| lg | 20pt | Section padding |
| xl | 24pt | Card padding |
| xxl | 32pt | Section spacing |
| xxxl | 40pt | Large gaps |

### Screen Layout
- **Horizontal margin**: 20pt
- **Card padding**: 24pt

---

## Components

### Cards
- **Background**: White
- **Shadow**: Subtle depth `Color.black.opacity(0.06)`, radius 10pt, Y offset 4pt
- **Corner radius**: 16pt (medium)
- **No borders** - use shadows for modern depth

```swift
.background(DesignSystem.Colors.cardBackground)
.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
.shadow(
    color: Color.black.opacity(0.06),
    radius: 10,
    x: 0,
    y: 4
)
```

### Buttons

**Primary Button:**
- Background: Accent color (solid)
- Text: White
- Height: 46-50pt
- Corner radius: 10pt

**Secondary Button:**
- Background: White
- Border: 1pt default
- Text: Accent color
- Height: 44pt

### Category Tiles
- White background on off-white screen
- Subtle shadow for depth
- Icon in 12% opacity category color circle
- 16pt corner radius

### Progress Indicators
- Thin (2-3pt) strokes
- Neutral colors (textSecondary for fill)
- Simple dots or bars, not rings

### Tags/Pills
- Surface secondary background
- Tertiary text color
- Capsule shape
- Small padding (8-12pt horizontal, 4-6pt vertical)

---

## Icons

### Style
- Outline icons by default (Heroicons outline)
- Solid icons for selected states
- Regular weight, not bold

### Sizes
- Large: 44pt
- Medium: 28pt
- Small: 20pt

### Colors
- Default: textSecondary or textTertiary
- Selected: textPrimary or accent
- Category icons: category accent color

---

## Animations

### Removed Elements
- No confetti
- No rotating rays
- No continuous flickering
- No radial glows
- No shine/sweep effects

### Kept Animations (Subtle)
- Fade in/out: `easeOut(duration: 0.2-0.3)`
- Scale: 0.95-1.0 on appear
- Spring: `response: 0.25, damping: 0.85`

### Interaction Feedback
- Button press: scale to 0.98
- Haptic: light/medium on tap

---

## Accessibility

### Contrast
- Primary text: High contrast against white
- Secondary text: Sufficient contrast for readability
- Borders: Visible but subtle

### Touch Targets
- Minimum 44pt for interactive elements
- Generous tap areas on cards

### Motion
- Reduced animation duration
- No continuous animations
- Respect system reduce motion setting

---

## Implementation Notes

### View Modifiers
```swift
// Minimal card styling with shadow
func minimalCard() -> some View {
    self
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(
            color: Color.black.opacity(0.06),
            radius: 10,
            x: 0,
            y: 4
        )
}

// Primary button
func premiumButton() -> some View {
    self
        .font(DesignSystem.Typography.body(.medium))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(DesignSystem.Colors.accent)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
}
```

### File Structure
- `DesignSystem.swift` - All design tokens
- Views use DesignSystem constants for consistency

---

## Version History
- **v1.0** (2026-01-29): Initial gamified design
- **v2.0** (2026-02-01): Minimal UI overhaul - removed gradients, confetti, glows; muted color palette; border-based cards
- **v2.1** (2026-02-02): Modern typography update - switched from `.rounded` to `.default` (SF Pro); neutral background; shadow-based cards; increased corner radii to 16pt
