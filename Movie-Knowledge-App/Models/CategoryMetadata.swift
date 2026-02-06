//
//  CategoryMetadata.swift
//  Movie-Knowledge-App
//
//  Created by Codex on 6/2/2026.
//

import Foundation

struct CategoryMetadata {
    enum ContentType: String, Hashable {
        case people
        case films
        case behindTheScenes
        case awards
    }

    enum Region: String, Hashable {
        case hollywood
        case worldCinema
        case eraFocused
    }

    enum Difficulty: String, Hashable {
        case easy
        case intermediate
        case filmNerd
    }

    let title: String
    let contentTypes: Set<ContentType>
    let regions: Set<Region>
    let difficulty: Difficulty
    let highlights: [String]

    static func forCategory(title: String) -> CategoryMetadata? {
        entries[canonicalTitle(for: title)]
    }

    static func highlights(for title: String) -> [String] {
        forCategory(title: title)?.highlights ?? defaultHighlights
    }

    private static func canonicalTitle(for title: String) -> String {
        let cleaned = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return titleAliases[cleaned] ?? cleaned
    }

    private static let defaultHighlights: [String] = [
        "Engaging lessons",
        "Fascinating trivia",
        "Test your knowledge"
    ]

    private static let titleAliases: [String: String] = [
        "Core Film Knowledge": "The Essentials",
        "Film Craft and Behind the Scenes": "Behind the Scenes"
    ]

    private static let entries: [String: CategoryMetadata] = [
        "The Essentials": CategoryMetadata(
            title: "The Essentials",
            contentTypes: [.films],
            regions: [.hollywood],
            difficulty: .easy,
            highlights: [
                "Film history and milestones",
                "Iconic movie quotes",
                "Box office records"
            ]
        ),
        "Directors and Creators": CategoryMetadata(
            title: "Directors and Creators",
            contentTypes: [.people],
            regions: [],
            difficulty: .intermediate,
            highlights: [
                "Legendary filmmakers",
                "Signature directing styles",
                "Indie cinema pioneers"
            ]
        ),
        "Genres": CategoryMetadata(
            title: "Genres",
            contentTypes: [.films],
            regions: [],
            difficulty: .easy,
            highlights: [
                "Action, drama, comedy and more",
                "Genre conventions",
                "Crossover masterpieces"
            ]
        ),
        "World Cinema": CategoryMetadata(
            title: "World Cinema",
            contentTypes: [.films],
            regions: [.worldCinema],
            difficulty: .intermediate,
            highlights: [
                "International classics",
                "Cultural storytelling",
                "Award-winning foreign films"
            ]
        ),
        "Awards and Recognition": CategoryMetadata(
            title: "Awards and Recognition",
            contentTypes: [.awards],
            regions: [],
            difficulty: .intermediate,
            highlights: [
                "Oscar history and records",
                "Festival winners",
                "Critics' choice selections"
            ]
        ),
        "Behind the Scenes": CategoryMetadata(
            title: "Behind the Scenes",
            contentTypes: [.behindTheScenes],
            regions: [],
            difficulty: .filmNerd,
            highlights: [
                "Cinematography techniques",
                "Special effects mastery",
                "Screenwriting essentials"
            ]
        ),
        "Movie Eras": CategoryMetadata(
            title: "Movie Eras",
            contentTypes: [.films],
            regions: [.eraFocused],
            difficulty: .intermediate,
            highlights: [
                "Silent era to modern day",
                "Golden age classics",
                "Contemporary cinema"
            ]
        ),
        "Actors and Performances": CategoryMetadata(
            title: "Actors and Performances",
            contentTypes: [.people],
            regions: [],
            difficulty: .easy,
            highlights: [
                "Iconic performances",
                "Method acting legends",
                "On-screen chemistry"
            ]
        ),
        "Franchises and Series": CategoryMetadata(
            title: "Franchises and Series",
            contentTypes: [.films],
            regions: [.hollywood],
            difficulty: .easy,
            highlights: [
                "Epic saga knowledge",
                "Shared cinematic universes",
                "Iconic characters and stories"
            ]
        )
    ]
}
