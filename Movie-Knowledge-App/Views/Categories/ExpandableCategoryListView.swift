//
//  ExpandableCategoryListView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 30/1/2026.
//

import SwiftUI
import SwiftData

struct ExpandableCategoryListView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    @Query(sort: \CategoryModel.displayOrder) private var categories: [CategoryModel]

    @State private var expandedCategoryId: UUID? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            // Scrollable category list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(categories) { category in
                        ExpandableCategoryTile(
                            category: category,
                            progress: getCategoryProgress(for: category),
                            isExpanded: expandedCategoryId == category.id,
                            onTap: { handleTileTap(category) },
                            onContinue: { navigateToCategory(category) }
                        )
                        .animation(DesignSystem.Animations.smooth, value: expandedCategoryId)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.xl)
                .padding(.top, 16)
                .padding(.bottom, 60)
            }
        }
        .animation(DesignSystem.Animations.smooth, value: expandedCategoryId)
    }

    // MARK: - Actions

    private func handleTileTap(_ category: CategoryModel) {
        HapticManager.shared.medium()
        withAnimation(DesignSystem.Animations.smooth) {
            if expandedCategoryId == category.id {
                // Already expanded - collapse it
                expandedCategoryId = nil
            } else {
                // Expand this category
                expandedCategoryId = category.id
            }
        }
    }

    private func navigateToCategory(_ category: CategoryModel) {
        HapticManager.shared.medium()
        appState.activeCategory = category
    }

    // MARK: - Progress Calculation

    private func getCategoryProgress(for category: CategoryModel) -> Double {
        guard let profile = appState.userProfile else { return 0 }

        if let progress = profile.categoryProgress.first(where: { $0.categoryId == category.id }) {
            let totalSubCategories = category.subCategories.count
            guard totalSubCategories > 0 else { return 0 }
            return Double(progress.completedCount) / Double(totalSubCategories)
        }
        return 0
    }
}

#Preview {
    ExpandableCategoryListView()
        .environment(AppState())
        .modelContainer(for: [CategoryModel.self])
}
