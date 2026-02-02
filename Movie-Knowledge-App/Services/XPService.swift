//
//  XPService.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

final class XPService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - XP Calculation

    /// Award XP to the user profile
    func awardXP(_ amount: Int, to profile: UserProfile) {
        profile.currentXP += amount

        // Check for level up
        while profile.currentXP >= profile.nextLevelXP {
            levelUp(profile: profile)
        }

        try? context.save()
    }

    /// Calculate XP for a quiz result
    func calculateQuizXP(correctAnswers: Int, challenges: [Challenge]) -> Int {
        var totalXP = 0

        // Award XP only for correct answers based on difficulty
        for (index, challenge) in challenges.enumerated() {
            if index < correctAnswers {
                totalXP += challenge.xpReward
            }
        }

        return totalXP
    }

    // MARK: - Level Management

    /// Level up the user
    private func levelUp(profile: UserProfile) {
        profile.currentLevel += 1
        profile.currentXP -= profile.nextLevelXP

        // TODO: Trigger level up celebration animation
        print("🎉 Level up! Now level \(profile.currentLevel)")
    }

    /// Calculate progress to next level (0.0 to 1.0)
    func progressToNextLevel(for profile: UserProfile) -> Double {
        let nextLevelXP = profile.nextLevelXP
        guard nextLevelXP > 0 else { return 0.0 }
        return Double(profile.currentXP) / Double(nextLevelXP)
    }

    /// Get XP needed for next level
    func xpNeededForNextLevel(for profile: UserProfile) -> Int {
        return profile.nextLevelXP - profile.currentXP
    }
}
