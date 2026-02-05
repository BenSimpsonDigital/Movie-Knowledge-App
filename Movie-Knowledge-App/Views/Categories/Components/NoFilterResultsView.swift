//
//  NoFilterResultsView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct NoFilterResultsView: View {
    let searchQuery: String
    let hasFilters: Bool
    let onClearFilters: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Icon
            Image(systemName: hasFilters ? "line.3.horizontal.decrease.circle" : "magnifyingglass")
                .font(.system(size: 56))
                .foregroundStyle(DesignSystem.Colors.textTertiary)

            // Title
            Text(title)
                .font(DesignSystem.Typography.heading())
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)

            // Message
            Text(message)
                .font(DesignSystem.Typography.body())
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Clear filters button
            if hasFilters {
                Button(action: {
                    onClearFilters()
                    HapticManager.shared.medium()
                }) {
                    Text("Clear All Filters")
                        .depthButtonLabel(
                            font: DesignSystem.Typography.body(.semibold),
                            verticalPadding: 14,
                            fullWidth: false
                        )
                        .frame(width: 180)
                }
                .buttonStyle(DepthButtonStyle(cornerRadius: 12))
                .padding(.top, 8)
            }

            Spacer()
            Spacer()
        }
    }

    private var title: String {
        if !searchQuery.isEmpty {
            return "No results for \"\(searchQuery)\""
        } else if hasFilters {
            return "No matching categories"
        }
        return "No categories found"
    }

    private var message: String {
        if !searchQuery.isEmpty && hasFilters {
            return "Try adjusting your search or filters"
        } else if !searchQuery.isEmpty {
            return "Try a different search term"
        } else if hasFilters {
            return "Try removing some filters to see more categories"
        }
        return "Categories will appear here"
    }
}

#Preview {
    VStack {
        NoFilterResultsView(
            searchQuery: "Horror",
            hasFilters: true,
            onClearFilters: {}
        )
    }
    .background(DesignSystem.Colors.screenBackground)
}
