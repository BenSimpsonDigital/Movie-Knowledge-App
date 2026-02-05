//
//  UserPreferences.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class UserPreferences {
    @Attribute(.unique) var id: UUID
    var selectedInterests: [String]
    var dailyGoal: Int
    var notificationsEnabled: Bool
    var reminderTime: Date?
    var soundEnabled: Bool
    var hapticsEnabled: Bool
    var hasCompletedOnboarding: Bool
    var isSignedIn: Bool

    // Store user profile ID instead of relationship
    var userProfileId: UUID?

    // User-added categories for learning list
    @Relationship var addedCategories: [CategoryModel]

    // Category filter persistence
    var categoryCompletionFilter: String?
    var categoryContentTypeFilter: String?
    var categoryRegionFilter: String?
    var categoryLessonCountFilter: String?
    var categoryDifficultyFilter: String?

    init(
        id: UUID = UUID(),
        selectedInterests: [String] = [],
        dailyGoal: Int = 5,
        notificationsEnabled: Bool = false,
        reminderTime: Date? = nil,
        soundEnabled: Bool = true,
        hapticsEnabled: Bool = true,
        hasCompletedOnboarding: Bool = false,
        isSignedIn: Bool = false,
        userProfileId: UUID? = nil,
        addedCategories: [CategoryModel] = [],
        categoryCompletionFilter: String? = nil,
        categoryContentTypeFilter: String? = nil,
        categoryRegionFilter: String? = nil,
        categoryLessonCountFilter: String? = nil,
        categoryDifficultyFilter: String? = nil
    ) {
        self.id = id
        self.selectedInterests = selectedInterests
        self.dailyGoal = dailyGoal
        self.notificationsEnabled = notificationsEnabled
        self.reminderTime = reminderTime
        self.soundEnabled = soundEnabled
        self.hapticsEnabled = hapticsEnabled
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.isSignedIn = isSignedIn
        self.userProfileId = userProfileId
        self.addedCategories = addedCategories
        self.categoryCompletionFilter = categoryCompletionFilter
        self.categoryContentTypeFilter = categoryContentTypeFilter
        self.categoryRegionFilter = categoryRegionFilter
        self.categoryLessonCountFilter = categoryLessonCountFilter
        self.categoryDifficultyFilter = categoryDifficultyFilter
    }

    // Computed property for daily goal display
    var dailyGoalDisplayName: String {
        switch dailyGoal {
        case 3:
            return "Casual (3 questions)"
        case 5:
            return "Regular (5 questions)"
        case 10:
            return "Intense (10 questions)"
        default:
            return "\(dailyGoal) questions"
        }
    }
}
