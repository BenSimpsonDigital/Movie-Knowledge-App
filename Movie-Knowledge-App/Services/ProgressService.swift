//
//  ProgressService.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

final class ProgressService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Sub-Category Progress

    /// Mark a sub-category as completed
    func completeSubCategory(_ subCategory: SubCategory, for profile: UserProfile) {
        guard let category = subCategory.parentCategory else { return }

        // Get or create category progress
        let progress = getCategoryProgress(for: category.id, profile: profile)

        // Add to completed list if not already there
        if !progress.completedSubCategoryIds.contains(subCategory.id) {
            progress.completedSubCategoryIds.append(subCategory.id)
        }

        // Update current sub-category to next unlocked one
        updateCurrentSubCategory(for: progress, category: category)

        try? context.save()
    }

    /// Check if a sub-category is unlocked
    func isSubCategoryUnlocked(_ subCategory: SubCategory, for profile: UserProfile) -> Bool {
        guard let category = subCategory.parentCategory else { return false }

        let progress = getCategoryProgress(for: category.id, profile: profile)

        // First sub-category is always unlocked
        if subCategory.displayOrder == 0 {
            return true
        }

        // Check if previous sub-category is completed
        let sortedSubCategories = category.subCategories.sorted { $0.displayOrder < $1.displayOrder }
        guard let currentIndex = sortedSubCategories.firstIndex(where: { $0.id == subCategory.id }) else {
            return false
        }

        if currentIndex > 0 {
            let previousSubCategory = sortedSubCategories[currentIndex - 1]
            return progress.completedSubCategoryIds.contains(previousSubCategory.id)
        }

        return false
    }

    /// Get completion percentage for a category (0.0 to 1.0)
    func getCategoryCompletionPercentage(for category: CategoryModel, profile: UserProfile) -> Double {
        let progress = getCategoryProgress(for: category.id, profile: profile)
        let totalSubCategories = category.subCategories.count

        guard totalSubCategories > 0 else { return 0.0 }

        return Double(progress.completedSubCategoryIds.count) / Double(totalSubCategories)
    }

    /// Check if entire category is completed
    func isCategoryCompleted(_ category: CategoryModel, for profile: UserProfile) -> Bool {
        let progress = getCategoryProgress(for: category.id, profile: profile)
        return progress.completedSubCategoryIds.count == category.subCategories.count &&
               category.subCategories.count > 0
    }

    // MARK: - Private Helpers

    private func getCategoryProgress(for categoryId: UUID, profile: UserProfile) -> CategoryProgress {
        // Try to find existing progress
        if let existing = profile.categoryProgress.first(where: { $0.categoryId == categoryId }) {
            return existing
        }

        // Create new progress
        let newProgress = CategoryProgress(categoryId: categoryId)
        newProgress.userProfile = profile
        context.insert(newProgress)
        return newProgress
    }

    private func updateCurrentSubCategory(for progress: CategoryProgress, category: CategoryModel) {
        let sortedSubCategories = category.subCategories.sorted { $0.displayOrder < $1.displayOrder }

        // Find the first incomplete sub-category
        if let nextIncomplete = sortedSubCategories.first(where: {
            !progress.completedSubCategoryIds.contains($0.id)
        }) {
            progress.currentSubCategoryId = nextIncomplete.id
        } else {
            // All completed
            progress.currentSubCategoryId = nil
        }
    }

    // MARK: - Quiz Result Processing

    /// Process quiz completion and update progress
    func processQuizCompletion(
        subCategory: SubCategory,
        correctAnswers: Int,
        totalQuestions: Int,
        xpEarned: Int,
        profile: UserProfile
    ) {
        // Update user stats
        profile.totalQuestionsAnswered += totalQuestions
        profile.totalCorrectAnswers += correctAnswers

        // Mark sub-category as complete if passing score (e.g., 60%)
        let accuracy = Double(correctAnswers) / Double(totalQuestions)
        if accuracy >= 0.6 {
            completeSubCategory(subCategory, for: profile)

            // Update category XP
            if let category = subCategory.parentCategory {
                let progress = getCategoryProgress(for: category.id, profile: profile)
                progress.totalXPEarned += xpEarned
            }
        }

        try? context.save()
    }
}
