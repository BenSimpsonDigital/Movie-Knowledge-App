//
//  CategoryFilter.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import Foundation

// MARK: - Completion Status Filter

enum CompletionStatus: String, CaseIterable, Codable {
    case all = "All"
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"

    var displayName: String {
        rawValue
    }
}

// MARK: - Content Type Filter

enum ContentTypeFilter: String, CaseIterable, Codable {
    case all = "All"
    case people = "People"
    case films = "Films"
    case behindTheScenes = "Behind the Scenes"
    case awards = "Awards"

    var displayName: String {
        switch self {
        case .all: return "All Types"
        case .people: return "People"
        case .films: return "Films"
        case .behindTheScenes: return "Behind the Scenes"
        case .awards: return "Awards"
        }
    }

    /// Categories that match this content type
    var matchingCategoryTitles: Set<String> {
        switch self {
        case .all:
            return []
        case .people:
            return ["Directors and Creators", "Actors and Performances"]
        case .films:
            return ["Core Film Knowledge", "Genres", "Franchises and Series", "World Cinema", "Movie Eras"]
        case .behindTheScenes:
            return ["Behind the Scenes"]
        case .awards:
            return ["Awards and Recognition"]
        }
    }

    func matches(categoryTitle: String) -> Bool {
        guard self != .all else { return true }
        return matchingCategoryTitles.contains(categoryTitle)
    }
}

// MARK: - Region Filter

enum RegionFilter: String, CaseIterable, Codable {
    case all = "All"
    case hollywood = "Hollywood"
    case worldCinema = "World Cinema"
    case eraFocused = "Era-Focused"

    var displayName: String {
        switch self {
        case .all: return "All Regions"
        case .hollywood: return "Hollywood"
        case .worldCinema: return "World Cinema"
        case .eraFocused: return "Era-Focused"
        }
    }

    /// Categories that match this region
    var matchingCategoryTitles: Set<String> {
        switch self {
        case .all:
            return []
        case .hollywood:
            return ["Core Film Knowledge", "Franchises and Series"]
        case .worldCinema:
            return ["World Cinema"]
        case .eraFocused:
            return ["Movie Eras"]
        }
    }

    func matches(categoryTitle: String) -> Bool {
        guard self != .all else { return true }
        return matchingCategoryTitles.contains(categoryTitle)
    }
}

// MARK: - Lesson Count Filter

enum LessonCountFilter: String, CaseIterable, Codable {
    case all = "All"
    case few = "Few"
    case moderate = "Some"
    case many = "Many"

    var displayName: String {
        switch self {
        case .all: return "All Sizes"
        case .few: return "1-4 Lessons"
        case .moderate: return "5-7 Lessons"
        case .many: return "8+ Lessons"
        }
    }

    func matches(lessonCount: Int) -> Bool {
        switch self {
        case .all: return true
        case .few: return lessonCount >= 1 && lessonCount <= 4
        case .moderate: return lessonCount >= 5 && lessonCount <= 7
        case .many: return lessonCount >= 8
        }
    }
}

// MARK: - Difficulty Filter

enum DifficultyFilter: String, CaseIterable, Codable {
    case all = "All"
    case easy = "Easy"
    case intermediate = "Intermediate"
    case filmNerd = "Film Nerd"

    var displayName: String {
        switch self {
        case .all: return "All Levels"
        case .easy: return "Easy"
        case .intermediate: return "Intermediate"
        case .filmNerd: return "Film Nerd"
        }
    }

    /// Categories that match this difficulty level
    var matchingCategoryTitles: Set<String> {
        switch self {
        case .all:
            return []
        case .easy:
            return ["Core Film Knowledge", "Genres", "Actors and Performances", "Franchises and Series"]
        case .intermediate:
            return ["Directors and Creators", "World Cinema", "Movie Eras", "Awards and Recognition"]
        case .filmNerd:
            return ["Behind the Scenes", "Film Craft and Behind the Scenes"]
        }
    }

    func matches(categoryTitle: String) -> Bool {
        guard self != .all else { return true }
        return matchingCategoryTitles.contains(categoryTitle)
    }
}
