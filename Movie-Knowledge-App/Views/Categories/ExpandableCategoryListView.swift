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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \CategoryModel.displayOrder) private var categories: [CategoryModel]

    @State private var filterViewModel = CategoryFilterViewModel()
    @State private var selectedCategory: SelectedCategory?
    @State private var previewCategory: CategoryModel?
    @State private var dailyFocus: DailyFocus?
    @State private var isSearchExpanded = false
    @State private var isProfilePresented = false
    @FocusState private var isSearchFocused: Bool

    private var filteredCategories: [CategoryModel] {
        let progress = appState.userProfile?.categoryProgress ?? []
        return filterViewModel.filteredCategories(from: categories, categoryProgress: progress)
    }

    private var categoryOfTheDay: CategoryModel? {
        guard !filteredCategories.isEmpty else { return nil }
        let dayIndex = Calendar.current.component(.day, from: Date()) % filteredCategories.count
        return filteredCategories[dayIndex]
    }

    private var featuredCategoryId: UUID? {
        isDiscoveryMode ? categoryOfTheDay?.id : nil
    }

    private var continueCategory: CategoryModel? {
        if let lastPlayed = appState.lastPlayedCategory {
            return lastPlayed
        }
        return categories.first { $0.title == "The Essentials" } ?? categories.first
    }

    private var addedCategories: [CategoryModel] {
        appState.userPreferences?.addedCategories ?? []
    }

    private var isDiscoveryMode: Bool {
        !filterViewModel.hasActiveFilters
    }

    private var searchAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.1) : .easeInOut(duration: 0.25)
    }

    private var searchTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .opacity.combined(with: .offset(y: 12)),
            removal: .opacity.combined(with: .offset(y: -12))
        )
    }

    private var isPreviewPresented: Binding<Bool> {
        Binding(
            get: { previewCategory != nil },
            set: { isPresented in
                if !isPresented {
                    previewCategory = nil
                }
            }
        )
    }

    var body: some View {
        ZStack {
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar

                if filteredCategories.isEmpty {
                    emptyResultsContent
                } else {
                    categoryList
                }
            }
        }
        .sheet(isPresented: $filterViewModel.isFilterSheetPresented) {
            CategoryFilterSheet(viewModel: filterViewModel)
        }
        .sheet(isPresented: isPreviewPresented) {
            if let previewCategory {
                CategoryPreviewSheet(
                    category: previewCategory,
                    progress: getCategoryProgress(for: previewCategory),
                    onStart: {
                        startQuickLesson(for: previewCategory)
                    },
                    onOpenCategory: {
                        navigateToCategory(previewCategory)
                    }
                )
            }
        }
        .navigationDestination(isPresented: $isProfilePresented) {
            ProfileView()
                .environment(appState)
        }
        .navigationDestination(item: $selectedCategory) { destination in
            SubCategoryListView(categoryId: destination.id)
                .environment(appState)
        }
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
        .onAppear {
            filterViewModel.configure(
                preferences: appState.userPreferences,
                profile: appState.userProfile
            )
            loadDailyFocus()
        }
        .onChange(of: appState.isQuizActive) { _, isActive in
            if !isActive {
                loadDailyFocus()
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(action: { isProfilePresented = true }) {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        Circle()
                            .fill(DesignSystem.Colors.surfaceSecondary)
                            .frame(
                                width: DesignSystem.Dimensions.avatarSmall,
                                height: DesignSystem.Dimensions.avatarSmall
                            )
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                            }

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Level \(appState.userProfile?.currentLevel ?? 1)")
                                .font(DesignSystem.Typography.body(.medium))
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                                .lineLimit(1)

                            Text(userTitle(for: appState.userProfile?.currentLevel ?? 1))
                                .font(DesignSystem.Typography.caption())
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                if !isSearchExpanded {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        HeaderIconButton(systemName: "magnifyingglass") {
                            withAnimation(searchAnimation) {
                                isSearchExpanded = true
                            }
                        }

                        HeaderIconButton(
                            systemName: "line.3.horizontal.decrease",
                            showsBadge: filterViewModel.activeFilterCount > 0,
                            badgeText: "\(filterViewModel.activeFilterCount)"
                        ) {
                            filterViewModel.isFilterSheetPresented = true
                        }
                    }
                }
            }

            if isSearchExpanded {
                CategorySearchBar(
                    searchText: $filterViewModel.searchQuery,
                    onClear: { filterViewModel.clearSearch() },
                    onCollapse: collapseSearch,
                    shouldFocusOnAppear: true,
                    focusState: $isSearchFocused
                )
                .frame(maxWidth: .infinity, alignment: .trailing)
                .transition(searchTransition)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.xl)
        .padding(.top, DesignSystem.Spacing.lg)
        .padding(.bottom, DesignSystem.Spacing.sm)
    }

    // MARK: - Main Content

    private var categoryList: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Spacing.lg) {
                DailyFocusCard(
                    focus: dailyFocus,
                    onStart: startTodaySession
                )
                .padding(.top, DesignSystem.Spacing.xs)

                if isDiscoveryMode, let continueCategory {
                    continueLearningCard(category: continueCategory)
                }

                if isDiscoveryMode, !addedCategories.isEmpty {
                    addedCategoriesSection
                }

                sectionHeader(title: isDiscoveryMode ? "All Categories" : "Matching Categories")

                ForEach(filteredCategories, id: \.id) { category in
                    ExpandableCategoryTile(
                        category: category,
                        progress: getCategoryProgress(for: category),
                        isFeatured: featuredCategoryId == category.id,
                        onTap: {
                            isSearchFocused = false
                            navigateToCategory(category)
                        },
                        onInfoTap: {
                            isSearchFocused = false
                            previewCategory = category
                            HapticManager.shared.light()
                        }
                    )
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.bottom, 56)
        }
        .onTapGesture {
            isSearchFocused = false
        }
    }

    private var emptyResultsContent: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.lg) {
                DailyFocusCard(
                    focus: dailyFocus,
                    onStart: startTodaySession
                )
                .padding(.top, DesignSystem.Spacing.xs)

                NoFilterResultsView(
                    searchQuery: filterViewModel.searchQuery,
                    hasFilters: filterViewModel.hasActiveFilters,
                    onClearFilters: {
                        withAnimation(reduceMotion ? .none : DesignSystem.Animations.smooth) {
                            filterViewModel.clearEverything()
                        }
                    }
                )
                .frame(minHeight: 320)
            }
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.bottom, 56)
        }
    }

    // MARK: - Continue Card

    private func continueLearningCard(category: CategoryModel) -> some View {
        Button(action: {
            HapticManager.shared.medium()
            navigateToCategory(category)
        }) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                Text("CONTINUE LEARNING")
                    .font(DesignSystem.Typography.caption(.medium))
                    .foregroundStyle(category.accentColor)
                    .tracking(0.5)

                Text(category.title)
                    .font(DesignSystem.Typography.heading())
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)

                Text("Pick up where you left off")
                    .font(DesignSystem.Typography.body())
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)

                HStack(spacing: DesignSystem.Spacing.xs) {
                    Text("Open category")
                        .font(DesignSystem.Typography.body(.medium))
                        .foregroundStyle(category.accentColor)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(category.accentColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DesignSystem.Spacing.xl)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    // MARK: - In Progress

    private var addedCategoriesSection: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            Text("In Progress")
                .font(DesignSystem.Typography.body(.semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(addedCategories, id: \.id) { category in
                        inProgressCategoryCard(category: category)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private func inProgressCategoryCard(category: CategoryModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Circle()
                    .fill(category.accentColor.opacity(0.15))
                    .frame(width: 38, height: 38)
                    .overlay {
                        Image(systemName: category.iconName ?? "film")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(category.accentColor)
                    }

                Spacer()

                Button(action: {
                    HapticManager.shared.light()
                    toggleAddedCategory(category)
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                        .frame(width: 22, height: 22)
                        .background(DesignSystem.Colors.surfaceSecondary)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.top, DesignSystem.Spacing.md)

            Spacer()

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(category.title)
                    .font(DesignSystem.Typography.body(.medium))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                let progress = getCategoryProgress(for: category)
                let percentage = Int(progress * 100)

                HStack(spacing: DesignSystem.Spacing.xs) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(DesignSystem.Colors.surfaceSecondary)
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(category.accentColor)
                                .frame(width: max(0, geo.size.width * progress), height: 4)
                        }
                    }
                    .frame(height: 4)

                    Text("\(percentage)%")
                        .font(DesignSystem.Typography.caption(.medium))
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .frame(minWidth: 34, alignment: .trailing)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.md)
            .padding(.bottom, DesignSystem.Spacing.md)
        }
        .frame(width: 180, height: 136)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusMedium, style: .continuous)
                .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: DesignSystem.Effects.borderWidth)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            HapticManager.shared.light()
            navigateToCategory(category)
        }
    }

    // MARK: - Section Header

    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.body(.semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Spacer()
        }
    }

    // MARK: - Actions

    private func navigateToCategory(_ category: CategoryModel) {
        HapticManager.shared.medium()
        selectedCategory = SelectedCategory(id: category.id)
    }

    private func collapseSearch() {
        withAnimation(.none) {
            isSearchExpanded = false
        }
        filterViewModel.clearSearch()
    }

    private func toggleAddedCategory(_ category: CategoryModel) {
        guard let preferences = appState.userPreferences else { return }
        if let index = preferences.addedCategories.firstIndex(where: { $0.id == category.id }) {
            preferences.addedCategories.remove(at: index)
            try? context.save()
        }
    }

    private func startTodaySession() {
        guard let focus = dailyFocus else { return }
        guard !focus.isCompleted && !focus.isComingSoon else { return }

        HapticManager.shared.medium()
        appState.updateLastPlayed(category: focus.category, subCategory: focus.subCategory, context: context)
        appState.startQuiz(for: focus.subCategory)
    }

    private func startQuickLesson(for category: CategoryModel) {
        guard let subCategory = nextSubCategoryToStart(in: category) else {
            navigateToCategory(category)
            return
        }

        HapticManager.shared.medium()
        appState.updateLastPlayed(category: category, subCategory: subCategory, context: context)
        appState.startQuiz(for: subCategory)
    }

    private func nextSubCategoryToStart(in category: CategoryModel) -> SubCategory? {
        let ordered = category.subCategories.sorted { $0.displayOrder < $1.displayOrder }
        guard let profile = appState.userProfile else { return ordered.first }

        let completedIds = Set(
            profile.categoryProgress
                .first(where: { $0.categoryId == category.id })?
                .completedSubCategoryIds ?? []
        )

        if let progressService = appState.progressService {
            if let nextUnlockedIncomplete = ordered.first(where: {
                !completedIds.contains($0.id) && progressService.isSubCategoryUnlocked($0, for: profile)
            }) {
                return nextUnlockedIncomplete
            }

            if let firstUnlocked = ordered.first(where: {
                progressService.isSubCategoryUnlocked($0, for: profile)
            }) {
                return firstUnlocked
            }
        }

        if let nextIncomplete = ordered.first(where: { !completedIds.contains($0.id) }) {
            return nextIncomplete
        }

        return ordered.first
    }

    private func getCategoryProgress(for category: CategoryModel) -> Double {
        guard let profile = appState.userProfile else { return 0 }
        guard let progress = profile.categoryProgress.first(where: { $0.categoryId == category.id }) else {
            return 0
        }

        let totalSubCategories = category.subCategories.count
        guard totalSubCategories > 0 else { return 0 }
        return Double(progress.completedCount) / Double(totalSubCategories)
    }

    private func loadDailyFocus() {
        guard let profile = appState.userProfile else {
            dailyFocus = nil
            return
        }

        let focusService = DailyFocusService(context: context)
        dailyFocus = focusService.getTodayFocus(for: profile)
    }

    private func userTitle(for level: Int) -> String {
        switch level {
        case 1...4: return "Casual Viewer"
        case 5...9: return "Film Enthusiast"
        case 10...14: return "Cinema Fan"
        case 15...19: return "Film Buff"
        case 20...29: return "Film Aficionado"
        case 30...39: return "Cinema Connoisseur"
        case 40...49: return "Screen Scholar"
        case 50...69: return "Film Historian"
        case 70...99: return "Cinema Master"
        default: return "Film Legend"
        }
    }
}

private struct SelectedCategory: Hashable, Identifiable {
    let id: UUID
}

#Preview {
    ExpandableCategoryListView()
        .environment(AppState())
        .modelContainer(for: [CategoryModel.self, UserProfile.self, SubCategory.self, UserPreferences.self])
}
