//
//  Category.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let tag: String?
    let iconName: String?
    let accentColor: Color
}

// MARK: - Sample Data
extension Category {
    static let allCategories: [Category] = [
        Category(
            title: "Classic Cinema",
            subtitle: "Timeless masterpieces from the golden age",
            tag: "TOP PICK",
            iconName: "film.stack",
            accentColor: Color(red: 0.90, green: 0.86, blue: 0.82)
        ),
        Category(
            title: "Sci-Fi Spectacles",
            subtitle: "Journey to distant galaxies and future worlds",
            tag: "NEW",
            iconName: "sparkles",
            accentColor: Color(red: 0.78, green: 0.86, blue: 0.94)
        ),
        Category(
            title: "Romantic Comedies",
            subtitle: "Love stories that make you laugh and cry",
            tag: nil,
            iconName: "heart.circle",
            accentColor: Color(red: 1.0, green: 0.86, blue: 0.90)
        ),
        Category(
            title: "Action Thrillers",
            subtitle: "Edge-of-your-seat adventures and suspense",
            tag: "POPULAR",
            iconName: "bolt.fill",
            accentColor: Color(red: 0.82, green: 0.84, blue: 0.86)
        ),
        Category(
            title: "Horror Nights",
            subtitle: "Spine-tingling tales of terror",
            tag: nil,
            iconName: "moon.stars",
            accentColor: Color(red: 0.71, green: 0.63, blue: 0.78)
        ),
        Category(
            title: "Documentaries",
            subtitle: "Real stories that inspire and inform",
            tag: nil,
            iconName: "doc.text",
            accentColor: Color(red: 0.78, green: 0.86, blue: 0.78)
        ),
        Category(
            title: "Animated Adventures",
            subtitle: "Imagination brought to life",
            tag: "FAMILY",
            iconName: "star.fill",
            accentColor: Color(red: 1.0, green: 0.94, blue: 0.78)
        ),
        Category(
            title: "Foreign Films",
            subtitle: "Discover cinema from around the world",
            tag: nil,
            iconName: "globe",
            accentColor: Color(red: 0.90, green: 0.78, blue: 0.71)
        ),
        Category(
            title: "Film Noir",
            subtitle: "Dark mysteries in shadow and light",
            tag: "CLASSIC",
            iconName: "theatermasks",
            accentColor: Color(red: 0.60, green: 0.60, blue: 0.62)
        ),
        Category(
            title: "Superhero Sagas",
            subtitle: "Epic tales of heroes and villains",
            tag: "TRENDING",
            iconName: "bolt.shield",
            accentColor: Color(red: 0.68, green: 0.82, blue: 0.96)
        ),
        Category(
            title: "Coming of Age",
            subtitle: "Stories of growth, discovery, and change",
            tag: nil,
            iconName: "figure.walk",
            accentColor: Color(red: 1.0, green: 0.88, blue: 0.78)
        ),
        Category(
            title: "Crime Dramas",
            subtitle: "Complex narratives of law and disorder",
            tag: nil,
            iconName: "lock.shield",
            accentColor: Color(red: 0.78, green: 0.47, blue: 0.51)
        )
    ]
}
