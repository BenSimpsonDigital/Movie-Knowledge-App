//
//  SubCategory.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class SubCategory {
    @Attribute(.unique) var id: UUID
    var title: String
    var descriptionText: String
    var displayOrder: Int
    var keyFacts: [String]
    var estimatedMinutes: Int

    // Relationships
    @Relationship var parentCategory: CategoryModel?
    @Relationship(deleteRule: .cascade) var challenges: [Challenge]

    init(
        id: UUID = UUID(),
        title: String,
        descriptionText: String,
        displayOrder: Int,
        keyFacts: [String] = [],
        estimatedMinutes: Int = 5
    ) {
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.displayOrder = displayOrder
        self.keyFacts = keyFacts
        self.estimatedMinutes = estimatedMinutes
        self.challenges = []
    }

    // Computed properties
    var totalChallenges: Int {
        challenges.count
    }
}
