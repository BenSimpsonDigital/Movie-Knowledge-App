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
    @State private var selectedCategoryId: UUID? = nil
    @State private var expandedCategoryId: UUID? = nil
    @State private var isSearchExpanded = false
    @State private var isProfilePresented = false
    @FocusState private var isSearchFocused: Bool

    // MARK: - Computed Properties

    private var filteredCategories: [CategoryModel] {
        let progress = appState.userProfile?.categoryProgress ?? []
        return filterViewModel.filteredCategories(from: categories, categoryProgress: progress)
    }
    
    private var categoryOfTheDay: CategoryModel? {
        guard !filteredCategories.isEmpty else { return nil }
        let dayIndex = Calendar.current.component(.day, from: Date()) % filteredCategories.count
        return filteredCategories[dayIndex]
    }
    
    private var continueCategory: CategoryModel? {
        // Priority 1: Last played category
        if let lastPlayed = appState.lastPlayedCategory {
            return lastPlayed
        }
        // Priority 2: Suggested category ("The Essentials")
        return filteredCategories.first { $0.title == "The Essentials" }
            ?? filteredCategories.first
    }
    
    private var isLastPlayed: Bool {
        appState.lastPlayedCategory != nil
    }
    
    private var addedCategories: [CategoryModel] {
        appState.userPreferences?.addedCategories ?? []
    }

    private var filterAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.1) : DesignSystem.Animations.smooth
    }

    private var searchAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.1) : .easeInOut(duration: 0.35)
    }

    private var searchTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .opacity.combined(with: .offset(y: 18)),
            removal: .opacity.combined(with: .offset(y: -18))
        )
    }

    private var userName: String {
        appState.userProfile?.username ?? "Ben"
    }

    private var userLevelText: String {
        let level = appState.userProfile?.currentLevel ?? 1
        let title = getUserTitle(for: level)
        return "Lvl \(level) • \(title)"
    }

    private var userStreak: Int {
        appState.userProfile?.currentStreak ?? 0
    }

    private var streakBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.system(size: 12, weight: .semibold))
            Text("\(userStreak)")
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.2))
        .clipShape(Capsule())
        .accessibilityLabel("Streak \(userStreak) days")
    }
    
    private func getUserTitle(for level: Int) -> String {
        switch level {
        case 1...4:
            return "Casual Viewer"
        case 5...9:
            return "Film Enthusiast"
        case 10...14:
            return "Cinema Fan"
        case 15...19:
            return "Ben"
        case 20...29:
            return "Film Aficionado"
        case 30...39:
            return "Cinema Connoisseur"
        case 40...49:
            return "Screen Scholar"
        case 50...69:
            return "Film Historian"
        case 70...99:
            return "Cinema Master"
        case 100...:
            return "Film Legend"
        default:
            return "Casual Viewer"
        }
    }

    // MARK: - First-Time User Detection

    private var isFirstTimeUser: Bool {
        (appState.userProfile?.totalQuestionsAnswered ?? 0) == 0
    }

    // MARK: - Overall Progress Calculation

    private func categoryProgress(for category: CategoryModel) -> Double {
        guard let profile = appState.userProfile else { return 0 }
        let total = category.subCategories.count
        guard total > 0 else { return 0 }
        
        let progress = profile.categoryProgress.first { $0.categoryId == category.id }
        let completed = progress?.completedCount ?? 0
        
        return Double(completed) / Double(total)
    }

    private func completedSubCategoriesCount(for category: CategoryModel) -> Int {
        guard let profile = appState.userProfile else { return 0 }
        let progress = profile.categoryProgress.first { $0.categoryId == category.id }
        return progress?.completedCount ?? 0
    }

    private func totalSubCategoriesCount(for category: CategoryModel) -> Int {
        return category.subCategories.count
    }

    private var welcomeGreeting: String {
        isFirstTimeUser ? "Welcome, \(userName)!" : "Welcome back, \(userName)!"
    }

    private var welcomeMessage: String {
        if isFirstTimeUser {
            return "Let's start with your first category"
        } else if let lastSubCategory = appState.lastPlayedSubCategory {
            return "Continue: \(lastSubCategory.title)"
        } else {
            return "Pick up where you left off"
        }
    }

    private var progressBarColor: Color {
        appState.lastPlayedCategory?.accentColor ?? DesignSystem.Colors.accent
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar

                // Content
                if filteredCategories.isEmpty {
                    NoFilterResultsView(
                        searchQuery: filterViewModel.searchQuery,
                        hasFilters: filterViewModel.hasActiveFilters,
                        onClearFilters: {
                            withAnimation(filterAnimation) {
                                filterViewModel.clearEverything()
                            }
                        }
                    )
                } else {
                    categoryList
                }
            }
        }
        .sheet(isPresented: $filterViewModel.isFilterSheetPresented) {
            CategoryFilterSheet(viewModel: filterViewModel)
        }
        .navigationDestination(isPresented: $isProfilePresented) {
            ProfileView()
                .environment(appState)
        }
        .navigationDestination(item: $selectedCategoryId) { categoryId in
            SubCategoryListView(categoryId: categoryId)
                .environment(appState)
        }
        .onAppear {
            filterViewModel.configure(
                preferences: appState.userPreferences,
                profile: appState.userProfile
            )
        }
        .onChange(of: filteredCategories.map(\.id)) { _, newValue in
            if let expandedCategoryId, !newValue.contains(expandedCategoryId) {
                withAnimation(DesignSystem.Animations.snappy) {
                    self.expandedCategoryId = nil
                }
            }
        }
    }

    // MARK: - Header Bar

    private var headerBar: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center) {
                Button(action: { isProfilePresented = true }) {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        Circle()
                            .fill(DesignSystem.Colors.surfaceSecondary)
                            .frame(width: DesignSystem.Dimensions.avatarSmall, height: DesignSystem.Dimensions.avatarSmall)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                            }

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Level \(appState.userProfile?.currentLevel ?? 1)")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(DesignSystem.Colors.textPrimary)
                                .lineLimit(1)
                            
                            Text(getUserTitle(for: appState.userProfile?.currentLevel ?? 1))
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(DesignSystem.Colors.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                HStack(spacing: 12) {
                    if !isSearchExpanded {
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

    // MARK: - Category List

    private var categoryList: some View {
        ScrollViewReader { proxy in
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 28) {
                        // Welcome Section
                        if let continueCategory {
                            welcomeSection(category: continueCategory)
                                .padding(.top, 16)
                        }

                        if !addedCategories.isEmpty {
                            addedCategoriesSection
                        }
                        
                        // All Categories Section
                        sectionHeader(title: "All Categories")
                            .padding(.bottom, -8)
                        
                        VStack(spacing: 16) {
                            // Today's Pick - Featured Category
                            if let categoryOfTheDay {
                                FeaturedCategoryTile(
                                    category: categoryOfTheDay,
                                    onTap: { navigateToCategory(categoryOfTheDay) }
                                )
                            }
                            
                            ForEach(Array(filteredCategories.enumerated()), id: \.element.id) { index, category in
                                ExpandableCategoryTile(
                                    category: category,
                                    progress: getCategoryProgress(for: category),
                                    isExpanded: category.id == expandedCategoryId,
                                    isOtherExpanded: expandedCategoryId != nil && category.id != expandedCategoryId,
                                    onTap: { 
                                        isSearchFocused = false
                                        handleTileTap(category, proxy: proxy)
                                    },
                                    onContinue: {
                                        navigateToCategory(category)
                                        expandedCategoryId = nil
                                    }
                                )
                                .id(category.id)
                                .zIndex(category.id == expandedCategoryId ? 100 : 0)
                                .transition(categoryTransition)
                                .animation(
                                    reduceMotion
                                        ? .easeInOut(duration: 0.1)
                                        : DesignSystem.Animations.staggered(index: index, baseDelay: 0.03),
                                    value: filteredCategories.map(\.id)
                                )
                            }
                            
                            // More Coming Soon tile
                            moreComingSoonTile
                                .padding(.top, -8)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.xl)
                    .padding(.top, 4)
                    .padding(.bottom, 60)
                }
                .onTapGesture {
                    isSearchFocused = false
                    if expandedCategoryId != nil {
                        withAnimation(DesignSystem.Animations.smooth) {
                            expandedCategoryId = nil
                        }
                    }
                }
            }
        }
    }

    // MARK: - More Coming Soon Tile
    
    private var moreComingSoonTile: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    DesignSystem.Colors.textSecondary.opacity(0.15),
                                    DesignSystem.Colors.textSecondary.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }

                // Title
                Text("More Coming Soon")
                    .font(.custom("InstrumentSerif-Regular", size: 21).weight(.semibold))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .lineLimit(1)

                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous)
                .strokeBorder(
                    DesignSystem.Colors.borderDefault,
                    lineWidth: DesignSystem.Effects.borderWidth
                )
                .opacity(0.5)
        )
        .opacity(0.6)
    }

    // MARK: - In Progress Section

    private var addedCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("In Progress")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
            }
            .padding(.horizontal, DesignSystem.Spacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(addedCategories, id: \.id) { category in
                        inProgressCategoryCard(category: category)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.xl)
                .padding(.vertical, 2)
            }
        }
        .padding(.horizontal, -DesignSystem.Spacing.xl)
    }
    
    private func inProgressCategoryCard(category: CategoryModel) -> some View {
        Button(action: {
            HapticManager.shared.light()
            navigateToCategory(category)
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Header with icon and remove button
                HStack(spacing: 0) {
                    // Category icon
                    if let iconName = category.iconName {
                        ZStack {
                            Circle()
                                .fill(category.accentColor.opacity(0.15))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: iconName)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(category.accentColor)
                        }
                    }
                    
                    Spacer()
                    
                    // Remove button
                    Button(action: {
                        HapticManager.shared.light()
                        toggleAddedCategory(category)
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                            .frame(width: 20, height: 20)
                            .background(DesignSystem.Colors.surfaceSecondary)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
                
                // Category info
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    let progress = getCategoryProgress(for: category)
                    let percentage = Int(progress * 100)
                    
                    HStack(spacing: 6) {
                        // Progress bar
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
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(DesignSystem.Colors.textSecondary)
                            .frame(minWidth: 32, alignment: .trailing)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .frame(width: 180, height: 140)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.borderDefault, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Welcome Section
    
    private func welcomeSection(category: CategoryModel) -> some View {
        Button(action: {
            HapticManager.shared.medium()
            navigateToCategory(category)
        }) {
            ZStack(alignment: .topTrailing) {
                // Background: Dynamic gradient based on category color
                LinearGradient(
                    colors: [
                        category.accentColor.opacity(0.85),
                        category.accentColor.opacity(0.70)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .saturation(0.6)
                
                // Abstract decorative shape (film reel inspired)
                GeometryReader { geometry in
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: geometry.size.height * 1.4, height: geometry.size.height * 1.4)
                        .offset(x: geometry.size.width * 0.65, y: -geometry.size.height * 0.2)
                    
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: geometry.size.height * 1.0, height: geometry.size.height * 1.0)
                        .offset(x: geometry.size.width * 0.75, y: geometry.size.height * 0.3)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 12) {
                    // Greeting
                    Text(welcomeGreeting)
                        .font(.custom("InstrumentSerif-Regular", size: 30))
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                    
                    // Contextual message
                Text(welcomeMessage)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.white.opacity(0.85))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()

                // Progress section
                    VStack(alignment: .leading, spacing: 8) {
                        let progress = categoryProgress(for: category)
                        let completed = completedSubCategoriesCount(for: category)
                        let total = totalSubCategoriesCount(for: category)
                        
                        // Progress bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.25))
                                    .frame(height: 8)
                                
                                // Progress fill
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .frame(width: max(0, geo.size.width * progress), height: 8)
                                    .animation(.easeInOut(duration: 0.5), value: progress)
                            }
                        }
                        .frame(height: 8)
                        
                        // Progress label with arrow
                        HStack {
                            Text("\(completed) of \(total) lessons")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.85))
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.9))
                        }
                    }
                }
                .padding(16)

                streakBadge
                    .padding(14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 175)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Effects.radiusLarge, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Section Header
    
    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Spacer()
        }
    }

    // MARK: - Transition

    private var categoryTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .asymmetric(
            insertion: .opacity.combined(with: .move(edge: .top)),
            removal: .opacity.combined(with: .offset(y: 20))
        )
    }

    // MARK: - Actions

    private func handleTileTap(_ category: CategoryModel, proxy: ScrollViewProxy) {
        HapticManager.shared.medium()
        
        let isExpanding = expandedCategoryId != category.id
        
        withAnimation(DesignSystem.Animations.smooth) {
            expandedCategoryId = isExpanding ? category.id : nil
        }
        
        // Scroll to make tile visible only if it will be cut off after expansion
        if isExpanding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    proxy.scrollTo(category.id, anchor: .center)
                }
            }
        }
    }

    private func navigateToCategory(_ category: CategoryModel) {
        HapticManager.shared.medium()
        selectedCategoryId = category.id
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
