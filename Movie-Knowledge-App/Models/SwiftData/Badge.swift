//
//  Badge.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

@Model
final class Badge {
    @Attribute(.unique) var id: UUID
    var title: String
    var descriptionText: String
    var iconName: String
    var categoryId: UUID? // nil = global badge
    var earnedDate: Date

    // Relationship
    @Relationship var userProfile: UserProfile?

    init(
        id: UUID = UUID(),
        title: String,
        descriptionText: String,
        iconName: String,
        categoryId: UUID? = nil,
        earnedDate: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.iconName = iconName
        self.categoryId = categoryId
        self.earnedDate = earnedDate
    }
}
