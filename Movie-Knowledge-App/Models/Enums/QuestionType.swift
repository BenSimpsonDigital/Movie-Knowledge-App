//
//  QuestionType.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation

enum QuestionType: String, Codable, CaseIterable {
    case multipleChoice = "multiple_choice"
    case trueFalse = "true_false"
    case fillBlank = "fill_blank"
    case pickYear = "pick_year"
    case matchDirector = "match_director"

    var displayName: String {
        switch self {
        case .multipleChoice:
            return "Multiple Choice"
        case .trueFalse:
            return "True or False"
        case .fillBlank:
            return "Fill in the Blank"
        case .pickYear:
            return "Pick the Year"
        case .matchDirector:
            return "Match Director"
        }
    }
}
