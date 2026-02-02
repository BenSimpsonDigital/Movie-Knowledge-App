//
//  CategoryProgress.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class CategoryProgress {
    @Attribute(.unique) var id: UUID
    var categoryId: UUID
    var completedSubCategoryIds: [UUID]
    var currentSubCategoryId: UUID?
    var totalXPEarned: Int
    var lastPlayedDate: Date?
    var bestAccuracy: Double

    // Relationship
    @Relationship var userProfile: UserProfile?

    init(
        id: UUID = UUID(),
        categoryId: UUID,
        completedSubCategoryIds: [UUID] = [],
        currentSubCategoryId: UUID? = nil,
        totalXPEarned: Int = 0,
        lastPlayedDate: Date? = nil,
        bestAccuracy: Double = 0.0
    ) {
        self.id = id
        self.categoryId = categoryId
        self.completedSubCategoryIds = completedSubCategoryIds
        self.currentSubCategoryId = currentSubCategoryId
        self.totalXPEarned = totalXPEarned
        self.lastPlayedDate = lastPlayedDate
        self.bestAccuracy = bestAccuracy
    }

    var completedCount: Int {
        completedSubCategoryIds.count
    }
}
