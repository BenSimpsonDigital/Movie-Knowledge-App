//
//  CategoryCyclerView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

struct CategoryCyclerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    @Query(sort: \CategoryModel.displayOrder) private var categories: [CategoryModel]

    // MARK: - State
    @State private var selectedCategoryId: UUID?

    // MARK: - Grid Layout
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    // MARK: - Helper Methods
    private func calculateProgress(for category: CategoryModel) -> Double {
        guard let profile = appState.userProfile else { return 0.0 }

        let totalSubCategories = category.subCategories.count
        guard totalSubCategories > 0 else { return 0.0 }

        let progress = profile.categoryProgress.first { $0.categoryId == category.id }
        let completed = progress?.completedSubCategoryIds.count ?? 0

        return Double(completed) / Double(totalSubCategories)
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            // Background color
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            if categories.isEmpty {
                // Loading state
                ProgressView()
            } else {
                // Scrollable Grid
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(categories, id: \.id) { category in
                            CategoryTileView(
                                category: category,
                                progress: calculateProgress(for: category),
                                isSelected: selectedCategoryId == category.id
                            )
                            .frame(height: 180)
                            .onTapGesture {
                                handleTap(category)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.8), value: selectedCategoryId)
    }

    // MARK: - Interaction Handlers
    private func handleTap(_ category: CategoryModel) {
        // Visual selection feedback
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedCategoryId = category.id
        }

        // Haptic feedback
        HapticManager.shared.light()

        // Navigate after brief delay for visual feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            appState.activeCategory = category
        }
    }
}

// MARK: - Preview
#Preview {
    CategoryCyclerView()
        .modelContainer(for: [CategoryModel.self, UserProfile.self])
}
