//
//  CategoryModel.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class CategoryModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var subtitle: String
    var journeySubtitle: String
    var tag: String?
    var iconName: String?
    var colorRed: Double
    var colorGreen: Double
    var colorBlue: Double
    var displayOrder: Int

    // Relationships
    @Relationship(deleteRule: .cascade) var subCategories: [SubCategory]

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        journeySubtitle: String = "",
        tag: String? = nil,
        iconName: String? = nil,
        colorRed: Double,
        colorGreen: Double,
        colorBlue: Double,
        displayOrder: Int
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.journeySubtitle = journeySubtitle
        self.tag = tag
        self.iconName = iconName
        self.colorRed = colorRed
        self.colorGreen = colorGreen
        self.colorBlue = colorBlue
        self.displayOrder = displayOrder
        self.subCategories = []
    }

    // Computed property for SwiftUI Color
    var accentColor: Color {
        Color(red: colorRed, green: colorGreen, blue: colorBlue)
    }

    var sheetBackgroundColor: Color {
        let blend = 0.10
        let red = (1.0 - blend) + (colorRed * blend)
        let green = (1.0 - blend) + (colorGreen * blend)
        let blue = (1.0 - blend) + (colorBlue * blend)
        return Color(red: red, green: green, blue: blue)
    }
}
