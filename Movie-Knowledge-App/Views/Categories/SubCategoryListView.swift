//
//  SubCategoryListView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean subcategory list design
//

import SwiftUI
import SwiftData

struct SubCategoryListView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context

    let categoryId: UUID
    
    @State private var category: CategoryModel?
    @State private var subCategories: [SubCategory] = []

    private var sortedSubCategories: [SubCategory] {
        subCategories.sorted { $0.displayOrder < $1.displayOrder }
    }

    var body: some View {
        Group {
            if category != nil {
                ScrollView {
                    VStack(spacing: 24) {
                        // Category Hero
                        categoryHero

                        // Sub-category list
                        VStack(spacing: 12) {
                            ForEach(sortedSubCategories) { subCategory in
                                let index = sortedSubCategories.firstIndex(where: { $0.id == subCategory.id }) ?? 0
                                SubCategoryRow(
                                    subCategory: subCategory,
                                    index: index + 1,
                                    isLocked: isLocked(subCategory),
                                    isCompleted: isCompleted(subCategory)
                                )
                                .onTapGesture {
                                    handleTap(on: subCategory)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, DesignSystem.Dimensions.tabSafeBottomPadding)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: Binding(
                    get: { appState.isQuizActive },
                    set: { if !$0 { appState.endQuiz() } }
                )) {
                    if let activeSubCategory = appState.activeSubCategory {
                        QuizView(
                            subCategory: activeSubCategory,
                            appState: appState,
                            context: context
                        )
                        .environment(appState)
                    }
                }
            } else {
                VStack {
                    Text("Category not found")
                        .font(DesignSystem.Typography.body())
                    Text("Category ID: \(categoryId.uuidString)")
                        .font(DesignSystem.Typography.caption())
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }
        }
        .onAppear {
            loadCategory()
        }
    }
    
    private func loadCategory() {
        let descriptor = FetchDescriptor<CategoryModel>(
            predicate: #Predicate { $0.id == categoryId }
        )
        
        if let fetchedCategory = try? context.fetch(descriptor).first {
            category = fetchedCategory
            subCategories = fetchedCategory.subCategories
        }
    }

    // MARK: - Category Hero
    private var categoryHero: some View {
        Group {
            if let category = category {
                VStack(spacing: 12) {
                    // Icon
                    if let iconName = category.iconName {
                        Image(systemName: iconName)
                            .font(.system(size: 40, weight: .light))
                            .foregroundStyle(category.accentColor)
                    }

                    // Title
                    Text(category.title)
                        .font(.custom("InstrumentSerif-Regular", size: 24).weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .multilineTextAlignment(.center)

                    // Subtitle
                    Text(category.subtitle)
                        .font(DesignSystem.Typography.body())
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .multilineTextAlignment(.center)

                    // Progress
                    if let profile = appState.userProfile {
                        let progress = profile.categoryProgress.first { $0.categoryId == category.id }
                        let completed = progress?.completedSubCategoryIds.count ?? 0
                        let total = sortedSubCategories.count

                        Text("\(completed)/\(total) completed")
                            .font(DesignSystem.Typography.caption())
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Helper Methods
    private func isLocked(_ subCategory: SubCategory) -> Bool {
        guard let profile = appState.userProfile,
              let progressService = appState.progressService else {
            return subCategory.displayOrder != 0
        }

        return !progressService.isSubCategoryUnlocked(subCategory, for: profile)
    }

    private func isCompleted(_ subCategory: SubCategory) -> Bool {
        guard let profile = appState.userProfile else { return false }

        let progress = profile.categoryProgress.first { $0.categoryId == categoryId }
        return progress?.completedSubCategoryIds.contains(subCategory.id) ?? false
    }

    private func handleTap(on subCategory: SubCategory) {
        if isLocked(subCategory) {
            print("Lesson locked")
        } else {
            addCategoryToLearningList()
            
            // Update last played category and subcategory
            if let category = category {
                appState.updateLastPlayed(category: category, subCategory: subCategory, context: context)
            }
            
            appState.startQuiz(for: subCategory)
        }
    }

    private func addCategoryToLearningList() {
        guard let category = category,
              let preferences = appState.userPreferences else { return }

        if !preferences.addedCategories.contains(where: { $0.id == category.id }) {
            preferences.addedCategories.append(category)
            try? context.save()
        }
    }
}

// MARK: - Sub-Category Row Component

struct SubCategoryRow: View {
    let subCategory: SubCategory
    let index: Int
    let isLocked: Bool
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 14) {
            // Number/status indicator
            ZStack {
                Circle()
                    .fill(isCompleted
                        ? DesignSystem.Colors.textSecondary
                        : isLocked
                            ? DesignSystem.Colors.borderDefault
                            : DesignSystem.Colors.surfaceSecondary)
                    .frame(width: 36, height: 36)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                } else if isLocked {
                    Image(systemName: "lock")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                } else {
                    Text("\(index)")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
            }

            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(subCategory.title)
                    .font(DesignSystem.Typography.body(.medium))
                    .foregroundStyle(isLocked
                        ? DesignSystem.Colors.textTertiary
                        : DesignSystem.Colors.textPrimary)

                Text("\(subCategory.challenges.count) questions")
                    .font(DesignSystem.Typography.caption())
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
            }

            Spacer()

            // Chevron
            if !isLocked {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(DesignSystem.Colors.textTertiary)
            }
        }
        .padding(14)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
        )
        .opacity(isLocked ? 0.6 : 1.0)
    }
}

#Preview {
    let category = CategoryModel(
        title: "Classic Cinema",
        subtitle: "Timeless masterpieces from the golden age",
        tag: "TOP PICK",
        iconName: "film.stack",
        colorRed: 0.75,
        colorGreen: 0.68,
        colorBlue: 0.58,
        displayOrder: 0
    )

    return NavigationStack {
        SubCategoryListView(categoryId: category.id)
    }
    .environment(AppState())
    .modelContainer(for: [CategoryModel.self, UserProfile.self])
}
