//
//  AppState.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData
import Observation

@Observable
final class AppState {
    // Current user profile (singleton pattern)
    var userProfile: UserProfile?

    // User preferences
    var userPreferences: UserPreferences?

    // Onboarding state
    var hasCompletedOnboarding: Bool = false

    // Active category for quiz navigation
    var activeCategory: CategoryModel?
    var activeSubCategory: SubCategory?

    // Continue learning state
    var lastPlayedCategory: CategoryModel?
    var lastPlayedSubCategory: SubCategory?

    // Quiz state
    var isQuizActive: Bool = false
    var currentQuizChallenges: [Challenge] = []
    var remainingLives: Int = 3

    // Search state
    var searchQuery: String = ""

    // Services (will be injected)
    var progressService: ProgressService?
    var xpService: XPService?
    var streakService: StreakService?
    var badgeService: BadgeService?

    init() {
        // Services will be initialized after SwiftData context is available
    }

    // MARK: - Navigation Helpers

    func startQuiz(for subCategory: SubCategory) {
        self.activeSubCategory = subCategory
        self.currentQuizChallenges = subCategory.challenges
        self.isQuizActive = true
        self.remainingLives = 3
    }

    func endQuiz() {
        self.isQuizActive = false
        self.currentQuizChallenges = []
        self.activeSubCategory = nil
        self.remainingLives = 3
    }

    func loseLife() {
        if remainingLives > 0 {
            remainingLives -= 1
        }
    }

    var isGameOver: Bool {
        remainingLives <= 0
    }

    // MARK: - Service Initialization

    func initializeServices(context: ModelContext) {
        self.progressService = ProgressService(context: context)
        self.xpService = XPService(context: context)
        self.streakService = StreakService(context: context)
        self.badgeService = BadgeService(context: context)
    }

    // MARK: - User Profile Helpers

    func loadUserProfile(from context: ModelContext) {
        let descriptor = FetchDescriptor<UserProfile>()
        if let profiles = try? context.fetch(descriptor), let profile = profiles.first {
            self.userProfile = profile
        } else {
            // Create default profile on first launch
            let newProfile = UserProfile(
                username: "Ben",
                currentXP: 0,
                currentLevel: 1,
                currentStreak: 0,
                longestStreak: 0,
                totalCorrectAnswers: 0,
                totalQuestionsAnswered: 0
            )
            context.insert(newProfile)
            self.userProfile = newProfile
        }
    }

    // MARK: - User Preferences Helpers

    func loadUserPreferences(from context: ModelContext) {
        let descriptor = FetchDescriptor<UserPreferences>()
        if let preferences = try? context.fetch(descriptor), let prefs = preferences.first {
            self.userPreferences = prefs
            self.hasCompletedOnboarding = prefs.hasCompletedOnboarding
        } else {
            // Create default preferences on first launch
            let newPreferences = UserPreferences()
            context.insert(newPreferences)
            self.userPreferences = newPreferences
            self.hasCompletedOnboarding = false
        }
    }

    func completeOnboarding(context: ModelContext) {
        userPreferences?.hasCompletedOnboarding = true
        hasCompletedOnboarding = true
        try? context.save()
    }

    // MARK: - Continue Learning Helpers

    func updateLastPlayed(category: CategoryModel, subCategory: SubCategory, context: ModelContext) {
        userProfile?.lastPlayedCategoryId = category.id
        userProfile?.lastPlayedSubCategoryId = subCategory.id
        lastPlayedCategory = category
        lastPlayedSubCategory = subCategory
        try? context.save()
    }

    func loadLastPlayedContent(from context: ModelContext) {
        guard let profile = userProfile,
              let categoryId = profile.lastPlayedCategoryId,
              let subCategoryId = profile.lastPlayedSubCategoryId else {
            return
        }

        // Fetch last played category
        let categoryDescriptor = FetchDescriptor<CategoryModel>()
        if let categories = try? context.fetch(categoryDescriptor) {
            lastPlayedCategory = categories.first { $0.id == categoryId }
        }

        // Fetch last played subcategory
        let subCategoryDescriptor = FetchDescriptor<SubCategory>()
        if let subCategories = try? context.fetch(subCategoryDescriptor) {
            lastPlayedSubCategory = subCategories.first { $0.id == subCategoryId }
        }
    }
}
