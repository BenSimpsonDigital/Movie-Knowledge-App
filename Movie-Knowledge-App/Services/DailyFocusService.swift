//
//  DailyFocusService.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 3/2/2026.
//

import Foundation
import SwiftData

struct DailyFocus {
    let category: CategoryModel
    let subCategory: SubCategory
    let isComingSoon: Bool
    let isCompleted: Bool
}

final class DailyFocusService {
    private let context: ModelContext
    private let calendar: Calendar

    init(context: ModelContext, calendar: Calendar = .current) {
        self.context = context
        self.calendar = calendar
    }

    func getTodayFocus(for profile: UserProfile) -> DailyFocus? {
        let today = calendar.startOfDay(for: Date())

        if let focusDate = profile.dailyFocusDate,
           calendar.isDate(focusDate, inSameDayAs: today),
           let categoryId = profile.dailyFocusCategoryId,
           let subCategoryId = profile.dailyFocusSubCategoryId,
           let category = fetchCategory(by: categoryId),
           let subCategory = fetchSubCategory(by: subCategoryId) {
            return DailyFocus(
                category: category,
                subCategory: subCategory,
                isComingSoon: subCategory.challenges.isEmpty,
                isCompleted: profile.dailyFocusCompleted
            )
        }

        guard let newFocus = computeNewFocus(for: profile) else {
            return nil
        }

        profile.dailyFocusDate = today
        profile.dailyFocusCategoryId = newFocus.category.id
        profile.dailyFocusSubCategoryId = newFocus.subCategory.id
        profile.dailyFocusCompleted = false
        try? context.save()

        return DailyFocus(
            category: newFocus.category,
            subCategory: newFocus.subCategory,
            isComingSoon: newFocus.subCategory.challenges.isEmpty,
            isCompleted: false
        )
    }

    private func computeNewFocus(for profile: UserProfile) -> (category: CategoryModel, subCategory: SubCategory)? {
        if let lastCategoryId = profile.lastPlayedCategoryId,
           let lastCategory = fetchCategory(by: lastCategoryId),
           let nextSubCategory = nextIncompleteSubCategory(in: lastCategory, profile: profile) {
            return (lastCategory, nextSubCategory)
        }

        let categories = fetchCategoriesSorted()
        for category in categories {
            if let nextSubCategory = nextIncompleteSubCategory(in: category, profile: profile) {
                return (category, nextSubCategory)
            }
        }

        return nil
    }

    private func nextIncompleteSubCategory(in category: CategoryModel, profile: UserProfile) -> SubCategory? {
        let completedIds = profile.categoryProgress
            .first { $0.categoryId == category.id }?
            .completedSubCategoryIds ?? []

        return category.subCategories
            .sorted { $0.displayOrder < $1.displayOrder }
            .first { !completedIds.contains($0.id) }
    }

    private func fetchCategoriesSorted() -> [CategoryModel] {
        let descriptor = FetchDescriptor<CategoryModel>(
            sortBy: [SortDescriptor(\.displayOrder)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    private func fetchCategory(by id: UUID) -> CategoryModel? {
        let descriptor = FetchDescriptor<CategoryModel>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }

    private func fetchSubCategory(by id: UUID) -> SubCategory? {
        let descriptor = FetchDescriptor<SubCategory>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }
}
