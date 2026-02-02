//
//  Difficulty.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation

enum Difficulty: String, Codable, CaseIterable {
    case easy
    case medium
    case hard

    var xpMultiplier: Double {
        switch self {
        case .easy:
            return 1.0
        case .medium:
            return 1.5
        case .hard:
            return 2.0
        }
    }

    var baseXP: Int {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 15
        case .hard:
            return 20
        }
    }

    var displayName: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}
