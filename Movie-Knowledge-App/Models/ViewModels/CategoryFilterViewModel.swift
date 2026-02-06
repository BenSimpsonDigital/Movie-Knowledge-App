//
//  CategoryFilterViewModel.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import Foundation
import SwiftData
import Observation

@Observable
final class CategoryFilterViewModel {
    // MARK: - Filter State

    var searchQuery: String = ""
    var completionFilter: CompletionStatus = .all
    var contentTypeFilter: ContentTypeFilter = .all
    var regionFilter: RegionFilter = .all
    var lessonCountFilter: LessonCountFilter = .all
    var difficultyFilter: DifficultyFilter = .all

    // MARK: - UI State

    var isFilterSheetPresented: Bool = false

    var activeFilterCount: Int {
        var count = 0
        if completionFilter != .all { count += 1 }
        if contentTypeFilter != .all { count += 1 }
        if regionFilter != .all { count += 1 }
        if lessonCountFilter != .all { count += 1 }
        if difficultyFilter != .all { count += 1 }
        return count
    }

    var hasActiveFilters: Bool {
        activeFilterCount > 0 || !searchQuery.isEmpty
    }

    // MARK: - Dependencies

    private weak var userPreferences: UserPreferences?
    private weak var userProfile: UserProfile?

    // MARK: - Debounce for Search

    private var searchTask: Task<Void, Never>?
    private var debouncedQuery: String = ""

    // MARK: - Configuration

    func configure(preferences: UserPreferences?, profile: UserProfile?) {
        self.userPreferences = preferences
        self.userProfile = profile
        loadPersistedFilters()
    }

    // MARK: - Filtering Logic

    func filteredCategories(
        from categories: [CategoryModel],
        categoryProgress: [CategoryProgress]
    ) -> [CategoryModel] {
        categories.filter { category in
            matchesSearch(category) &&
            matchesCompletionStatus(category, progress: categoryProgress) &&
            matchesContentType(category) &&
            matchesRegion(category) &&
            matchesLessonCount(category) &&
            matchesDifficulty(category)
        }
    }

    private func matchesSearch(_ category: CategoryModel) -> Bool {
        guard !searchQuery.isEmpty else { return true }
        let query = searchQuery.lowercased()
        if category.title.lowercased().contains(query) ||
            category.subtitle.lowercased().contains(query) {
            return true
        }

        if let metadata = CategoryMetadata.forCategory(title: category.title) {
            let metadataText = metadata.highlights.joined(separator: " ").lowercased()
            if metadataText.contains(query) {
                return true
            }
        }

        return false
    }

    private func matchesCompletionStatus(
        _ category: CategoryModel,
        progress: [CategoryProgress]
    ) -> Bool {
        guard completionFilter != .all else { return true }

        let categoryProgress = progress.first { $0.categoryId == category.id }
        let completedCount = categoryProgress?.completedCount ?? 0
        let totalCount = category.subCategories.count

        switch completionFilter {
        case .all:
            return true
        case .notStarted:
            return completedCount == 0
        case .inProgress:
            return completedCount > 0 && completedCount < totalCount
        case .completed:
            return completedCount >= totalCount && totalCount > 0
        }
    }

    private func matchesContentType(_ category: CategoryModel) -> Bool {
        contentTypeFilter.matches(categoryTitle: category.title)
    }

    private func matchesRegion(_ category: CategoryModel) -> Bool {
        regionFilter.matches(categoryTitle: category.title)
    }

    private func matchesLessonCount(_ category: CategoryModel) -> Bool {
        lessonCountFilter.matches(lessonCount: category.subCategories.count)
    }

    private func matchesDifficulty(_ category: CategoryModel) -> Bool {
        difficultyFilter.matches(categoryTitle: category.title)
    }

    // MARK: - Actions

    func clearAllFilters() {
        completionFilter = .all
        contentTypeFilter = .all
        regionFilter = .all
        lessonCountFilter = .all
        difficultyFilter = .all
        persistFilters()
    }

    func clearSearch() {
        searchQuery = ""
    }

    func clearEverything() {
        searchQuery = ""
        clearAllFilters()
    }

    // MARK: - Persistence

    func persistFilters() {
        userPreferences?.categoryCompletionFilter = completionFilter.rawValue
        userPreferences?.categoryContentTypeFilter = contentTypeFilter.rawValue
        userPreferences?.categoryRegionFilter = regionFilter.rawValue
        userPreferences?.categoryLessonCountFilter = lessonCountFilter.rawValue
        userPreferences?.categoryDifficultyFilter = difficultyFilter.rawValue
    }

    private func loadPersistedFilters() {
        if let raw = userPreferences?.categoryCompletionFilter,
           let status = CompletionStatus(rawValue: raw) {
            completionFilter = status
        }
        if let raw = userPreferences?.categoryContentTypeFilter,
           let type = ContentTypeFilter(rawValue: raw) {
            contentTypeFilter = type
        }
        if let raw = userPreferences?.categoryRegionFilter,
           let region = RegionFilter(rawValue: raw) {
            regionFilter = region
        }
        if let raw = userPreferences?.categoryLessonCountFilter,
           let count = LessonCountFilter(rawValue: raw) {
            lessonCountFilter = count
        }
        if let raw = userPreferences?.categoryDifficultyFilter,
           let difficulty = DifficultyFilter(rawValue: raw) {
            difficultyFilter = difficulty
        }
    }
}
