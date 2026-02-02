//
//  Movie.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class Movie {
    @Attribute(.unique) var id: UUID
    var title: String
    var releaseYear: Int
    var directorName: String
    var castNames: [String]
    var triviaFacts: [String]
    var posterImageName: String?

    // Store related IDs instead of relationships to avoid circular dependency issues
    var relatedCategoryIds: [UUID]
    var directorId: UUID?

    init(
        id: UUID = UUID(),
        title: String,
        releaseYear: Int,
        directorName: String,
        castNames: [String] = [],
        triviaFacts: [String] = [],
        posterImageName: String? = nil,
        relatedCategoryIds: [UUID] = [],
        directorId: UUID? = nil
    ) {
        self.id = id
        self.title = title
        self.releaseYear = releaseYear
        self.directorName = directorName
        self.castNames = castNames
        self.triviaFacts = triviaFacts
        self.posterImageName = posterImageName
        self.relatedCategoryIds = relatedCategoryIds
        self.directorId = directorId
    }

    // Computed property for formatted year
    var formattedYear: String {
        return "(\(releaseYear))"
    }

    // Computed property for cast display
    var castDisplay: String {
        guard !castNames.isEmpty else { return "Cast information unavailable" }
        return castNames.prefix(5).joined(separator: ", ")
    }
}
