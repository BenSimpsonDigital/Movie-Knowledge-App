//
//  StreakService.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

final class StreakService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Streak Management

    /// Check and update streak based on last active date
    func updateStreak(for profile: UserProfile) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let lastActiveDate = profile.lastActiveDate else {
            // First time user - start streak at 1
            profile.currentStreak = 1
            profile.lastActiveDate = Date()
            try? context.save()
            return
        }

        let lastActiveDay = calendar.startOfDay(for: lastActiveDate)
        let daysSinceLastActive = calendar.dateComponents([.day], from: lastActiveDay, to: today).day ?? 0

        switch daysSinceLastActive {
        case 0:
            // Already active today, no change
            break
        case 1:
            // Consecutive day - increment streak
            profile.currentStreak += 1
            if profile.currentStreak > profile.longestStreak {
                profile.longestStreak = profile.currentStreak
            }
            profile.lastActiveDate = Date()
        default:
            // Streak broken - reset to 1
            profile.currentStreak = 1
            profile.lastActiveDate = Date()
        }

        try? context.save()
    }

    /// Record daily lesson activity
    func recordDailyLesson(
        for profile: UserProfile,
        questionsAnswered: Int,
        correctAnswers: Int,
        xpEarned: Int
    ) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Check if we already have a record for today
        if let existingRecord = profile.dailyLessonHistory.first(where: {
            calendar.isDate($0.date, inSameDayAs: today)
        }) {
            // Update existing record
            existingRecord.questionsAnswered += questionsAnswered
            existingRecord.correctAnswers += correctAnswers
            existingRecord.xpEarned += xpEarned
        } else {
            // Create new record
            let record = DailyLessonRecord(
                date: today,
                questionsAnswered: questionsAnswered,
                correctAnswers: correctAnswers,
                xpEarned: xpEarned
            )
            record.userProfile = profile
            context.insert(record)
        }

        // Update streak
        updateStreak(for: profile)

        try? context.save()
    }

    /// Check if user has completed today's lesson
    func hasCompletedTodayLesson(for profile: UserProfile) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return profile.dailyLessonHistory.contains { record in
            calendar.isDate(record.date, inSameDayAs: today)
        }
    }

    /// Get streak status message
    func getStreakMessage(for profile: UserProfile) -> String {
        if profile.currentStreak == 0 {
            return "Start your streak today!"
        } else if profile.currentStreak == 1 {
            return "🔥 1 day streak"
        } else {
            return "🔥 \(profile.currentStreak) day streak"
        }
    }
}
