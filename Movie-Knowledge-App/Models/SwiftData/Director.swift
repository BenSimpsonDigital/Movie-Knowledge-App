//
//  Director.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class Director {
    @Attribute(.unique) var id: UUID
    var name: String
    var bio: String
    var filmographyHighlights: [String]
    var styleTraits: [String]
    var imageAssetName: String?

    // Store related IDs instead of direct relationships
    var relatedCategoryIds: [UUID]
    var movieIds: [UUID]

    init(
        id: UUID = UUID(),
        name: String,
        bio: String = "",
        filmographyHighlights: [String] = [],
        styleTraits: [String] = [],
        imageAssetName: String? = nil,
        relatedCategoryIds: [UUID] = [],
        movieIds: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.filmographyHighlights = filmographyHighlights
        self.styleTraits = styleTraits
        self.imageAssetName = imageAssetName
        self.relatedCategoryIds = relatedCategoryIds
        self.movieIds = movieIds
    }

    // Computed property for notable works display
    var notableWorksDisplay: String {
        guard !filmographyHighlights.isEmpty else { return "Filmography unavailable" }
        return filmographyHighlights.prefix(5).joined(separator: ", ")
    }

    // Computed property for style summary
    var styleSummary: String {
        guard !styleTraits.isEmpty else { return "Style information unavailable" }
        return styleTraits.joined(separator: " | ")
    }
}
