//
//  BadgeService.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

final class BadgeService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Badge Definitions

    private struct BadgeDefinition {
        let title: String
        let description: String
        let iconName: String
        let categoryId: UUID?
        let requirement: BadgeRequirement
    }

    private enum BadgeRequirement {
        case completedCategory(UUID)
        case reachedLevel(Int)
        case streakDays(Int)
        case totalXP(Int)
        case accuracy(Double, minQuestions: Int)
    }

    // MARK: - Badge Checking

    /// Check and award any newly earned badges after quiz completion
    func checkAndAwardBadges(for profile: UserProfile, category: CategoryModel? = nil) {
        let definitions = getAllBadgeDefinitions(categories: getAllCategories())

        for definition in definitions {
            // Skip if already earned
            if profile.earnedBadges.contains(where: { $0.title == definition.title }) {
                continue
            }

            // Check if requirement is met
            if meetsRequirement(definition.requirement, profile: profile) {
                awardBadge(definition: definition, to: profile)
            }
        }

        try? context.save()
    }

    /// Award a badge to the user
    private func awardBadge(definition: BadgeDefinition, to profile: UserProfile) {
        let badge = Badge(
            title: definition.title,
            descriptionText: definition.description,
            iconName: definition.iconName,
            categoryId: definition.categoryId
        )
        badge.userProfile = profile
        context.insert(badge)

        // TODO: Trigger badge unlock animation
        print("🏆 Badge earned: \(definition.title)")
    }

    /// Check if a requirement is met
    private func meetsRequirement(_ requirement: BadgeRequirement, profile: UserProfile) -> Bool {
        switch requirement {
        case .completedCategory(let categoryId):
            return profile.categoryProgress.contains { progress in
                progress.categoryId == categoryId &&
                isCategoryFullyCompleted(categoryId: categoryId, profile: profile)
            }

        case .reachedLevel(let level):
            return profile.currentLevel >= level

        case .streakDays(let days):
            return profile.currentStreak >= days

        case .totalXP(let xp):
            return profile.currentXP >= xp

        case .accuracy(let minAccuracy, let minQuestions):
            return profile.totalQuestionsAnswered >= minQuestions &&
                   profile.accuracyRate >= minAccuracy
        }
    }

    private func isCategoryFullyCompleted(categoryId: UUID, profile: UserProfile) -> Bool {
        guard let progress = profile.categoryProgress.first(where: { $0.categoryId == categoryId }) else {
            return false
        }

        // Get the actual category to check total sub-categories
        let categories = getAllCategories()
        guard let category = categories.first(where: { $0.id == categoryId }) else {
            return false
        }

        return progress.completedSubCategoryIds.count == category.subCategories.count &&
               category.subCategories.count > 0
    }

    // MARK: - Badge Definitions Factory

    private func getAllBadgeDefinitions(categories: [CategoryModel]) -> [BadgeDefinition] {
        var definitions: [BadgeDefinition] = []

        // Category completion badges
        for category in categories {
            definitions.append(BadgeDefinition(
                title: "\(category.title) Expert",
                description: "Complete all lessons in \(category.title)",
                iconName: category.iconName ?? "star.fill",
                categoryId: category.id,
                requirement: .completedCategory(category.id)
            ))
        }

        // Streak badges
        definitions.append(contentsOf: [
            BadgeDefinition(
                title: "Week Warrior",
                description: "Maintain a 7-day streak",
                iconName: "flame.fill",
                categoryId: nil,
                requirement: .streakDays(7)
            ),
            BadgeDefinition(
                title: "Month Master",
                description: "Maintain a 30-day streak",
                iconName: "flame.circle.fill",
                categoryId: nil,
                requirement: .streakDays(30)
            )
        ])

        // Level badges
        definitions.append(contentsOf: [
            BadgeDefinition(
                title: "Rising Star",
                description: "Reach level 5",
                iconName: "star.fill",
                categoryId: nil,
                requirement: .reachedLevel(5)
            ),
            BadgeDefinition(
                title: "Movie Master",
                description: "Reach level 10",
                iconName: "star.circle.fill",
                categoryId: nil,
                requirement: .reachedLevel(10)
            )
        ])

        // Accuracy badge
        definitions.append(BadgeDefinition(
            title: "Perfectionist",
            description: "Achieve 90% accuracy over 50 questions",
            iconName: "checkmark.seal.fill",
            categoryId: nil,
            requirement: .accuracy(0.9, minQuestions: 50)
        ))

        return definitions
    }

    private func getAllCategories() -> [CategoryModel] {
        let descriptor = FetchDescriptor<CategoryModel>()
        return (try? context.fetch(descriptor)) ?? []
    }
}
