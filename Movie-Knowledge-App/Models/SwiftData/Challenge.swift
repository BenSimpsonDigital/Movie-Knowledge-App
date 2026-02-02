//
//  Challenge.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class Challenge {
    @Attribute(.unique) var id: UUID
    var questionText: String
    var questionType: QuestionType
    var correctAnswer: String
    var wrongAnswers: [String]? // For multiple choice
    var explanation: String?
    var difficulty: Difficulty
    var xpReward: Int

    // Relationship
    @Relationship var subCategory: SubCategory?

    init(
        id: UUID = UUID(),
        questionText: String,
        questionType: QuestionType,
        correctAnswer: String,
        wrongAnswers: [String]? = nil,
        explanation: String? = nil,
        difficulty: Difficulty,
        xpReward: Int? = nil
    ) {
        self.id = id
        self.questionText = questionText
        self.questionType = questionType
        self.correctAnswer = correctAnswer
        self.wrongAnswers = wrongAnswers
        self.explanation = explanation
        self.difficulty = difficulty
        self.xpReward = xpReward ?? difficulty.baseXP
    }

    // Computed property for all answer options (for multiple choice)
    var allAnswers: [String] {
        guard questionType == .multipleChoice else { return [] }
        var answers = wrongAnswers ?? []
        answers.append(correctAnswer)
        return answers.shuffled()
    }
}
