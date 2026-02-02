//
//  UserProfile.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var username: String
    var currentXP: Int
    var currentLevel: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastActiveDate: Date?
    var totalCorrectAnswers: Int
    var totalQuestionsAnswered: Int
    var createdDate: Date

    // New properties for enhanced features
    var lastPlayedCategoryId: UUID?
    var lastPlayedSubCategoryId: UUID?
    var timeSpentMinutes: Int
    var favouriteCategoryIds: [UUID]

    // Relationships
    @Relationship(deleteRule: .cascade) var categoryProgress: [CategoryProgress]
    @Relationship(deleteRule: .cascade) var earnedBadges: [Badge]
    @Relationship(deleteRule: .cascade) var dailyLessonHistory: [DailyLessonRecord]

    init(
        id: UUID = UUID(),
        username: String = "Movie Buff",
        currentXP: Int = 0,
        currentLevel: Int = 1,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastActiveDate: Date? = nil,
        totalCorrectAnswers: Int = 0,
        totalQuestionsAnswered: Int = 0,
        createdDate: Date = Date(),
        lastPlayedCategoryId: UUID? = nil,
        lastPlayedSubCategoryId: UUID? = nil,
        timeSpentMinutes: Int = 0,
        favouriteCategoryIds: [UUID] = []
    ) {
        self.id = id
        self.username = username
        self.currentXP = currentXP
        self.currentLevel = currentLevel
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastActiveDate = lastActiveDate
        self.totalCorrectAnswers = totalCorrectAnswers
        self.totalQuestionsAnswered = totalQuestionsAnswered
        self.createdDate = createdDate
        self.lastPlayedCategoryId = lastPlayedCategoryId
        self.lastPlayedSubCategoryId = lastPlayedSubCategoryId
        self.timeSpentMinutes = timeSpentMinutes
        self.favouriteCategoryIds = favouriteCategoryIds
        self.categoryProgress = []
        self.earnedBadges = []
        self.dailyLessonHistory = []
    }

    // Computed properties
    var accuracyRate: Double {
        guard totalQuestionsAnswered > 0 else { return 0.0 }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAnswered)
    }

    var nextLevelXP: Int {
        // XP needed for next level: level * 100
        return currentLevel * 100
    }

    var progressToNextLevel: Double {
        guard nextLevelXP > 0 else { return 0.0 }
        return Double(currentXP) / Double(nextLevelXP)
    }
}
