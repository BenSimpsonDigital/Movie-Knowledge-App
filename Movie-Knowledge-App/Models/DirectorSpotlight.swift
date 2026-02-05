//
//  DirectorSpotlight.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

/// Represents a featured director spotlight configuration
struct DirectorSpotlight: Identifiable, Codable {
    let id: UUID
    let directorName: String
    let tagline: String
    let imageAssetName: String?
    let linkedCategoryTitle: String
    let linkedSubCategoryTitle: String?
    let accentColorRed: Double
    let accentColorGreen: Double
    let accentColorBlue: Double
    let startDate: Date
    let endDate: Date
    
    var accentColor: Color {
        Color(red: accentColorRed, green: accentColorGreen, blue: accentColorBlue)
    }
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }
    
    init(
        id: UUID = UUID(),
        directorName: String,
        tagline: String,
        imageAssetName: String? = nil,
        linkedCategoryTitle: String = "Directors and Creators",
        linkedSubCategoryTitle: String? = nil,
        accentColorRed: Double,
        accentColorGreen: Double,
        accentColorBlue: Double,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.directorName = directorName
        self.tagline = tagline
        self.imageAssetName = imageAssetName
        self.linkedCategoryTitle = linkedCategoryTitle
        self.linkedSubCategoryTitle = linkedSubCategoryTitle
        self.accentColorRed = accentColorRed
        self.accentColorGreen = accentColorGreen
        self.accentColorBlue = accentColorBlue
        self.startDate = startDate
        self.endDate = endDate
    }
}
