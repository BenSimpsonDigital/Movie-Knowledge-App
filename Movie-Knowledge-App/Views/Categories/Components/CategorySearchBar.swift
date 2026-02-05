//
//  CategorySearchBar.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct CategorySearchBar: View {
    @Binding var searchText: String
    let onClear: () -> Void
    var onCollapse: (() -> Void)? = nil
    var shouldFocusOnAppear: Bool = false
    var focusState: FocusState<Bool>.Binding? = nil

    @FocusState private var internalFocus: Bool
    
    private var isFocused: Bool {
        focusState?.wrappedValue ?? internalFocus
    }
    
    private var placeholderText: String {
        let suggestions = [
            "Try 'Directors', 'Horror', 'Cinematography'",
            "Search 'Spielberg' or 'Film Noir'",
            "Find 'Oscars', 'World Cinema', 'VFX'"
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return suggestions[dayOfYear % suggestions.count]
    }

    var body: some View {
        HStack(spacing: 12) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(DesignSystem.Colors.textSecondary)

            // Text field
            TextField(placeholderText, text: $searchText)
                .font(DesignSystem.Typography.body())
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .focused(focusState ?? $internalFocus)
                .accessibilityLabel("Search categories")
                .accessibilityHint("Enter text to filter categories by name")

            // Clear button (only when text exists)
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation(DesignSystem.Animations.snappy) {
                        onClear()
                    }
                    onCollapse?()
                    HapticManager.shared.light()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                .strokeBorder(
                    DesignSystem.Colors.borderDefault,
                    lineWidth: isFocused ? 1.5 : 1
                )
        )
        .animation(DesignSystem.Animations.snappy, value: isFocused)
        .onAppear {
            if shouldFocusOnAppear {
                if let focusState {
                    focusState.wrappedValue = true
                } else {
                    internalFocus = true
                }
            }
        }
        .onChange(of: isFocused) { _, newValue in
            if !newValue && searchText.isEmpty {
                onCollapse?()
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CategorySearchBar(searchText: .constant(""), onClear: {})
        CategorySearchBar(searchText: .constant("Action"), onClear: {})
    }
    .padding()
    .background(DesignSystem.Colors.screenBackground)
}
