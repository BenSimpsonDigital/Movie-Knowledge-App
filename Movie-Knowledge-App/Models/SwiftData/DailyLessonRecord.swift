//
//  DailyLessonRecord.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class DailyLessonRecord {
    @Attribute(.unique) var id: UUID
    var date: Date
    var questionsAnswered: Int
    var correctAnswers: Int
    var xpEarned: Int

    // Relationship
    @Relationship var userProfile: UserProfile?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        questionsAnswered: Int = 0,
        correctAnswers: Int = 0,
        xpEarned: Int = 0
    ) {
        self.id = id
        self.date = date
        self.questionsAnswered = questionsAnswered
        self.correctAnswers = correctAnswers
        self.xpEarned = xpEarned
    }

    var accuracyRate: Double {
        guard questionsAnswered > 0 else { return 0.0 }
        return Double(correctAnswers) / Double(questionsAnswered)
    }
}
