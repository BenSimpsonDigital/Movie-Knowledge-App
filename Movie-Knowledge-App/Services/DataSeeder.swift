//
//  DataSeeder.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation
import SwiftData

final class DataSeeder {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Main Seeding

    /// Seed all initial data if database is empty
    func seedDataIfNeeded() {
        // Check if data already exists
        let descriptor = FetchDescriptor<CategoryModel>()
        if let count = try? context.fetchCount(descriptor), count > 0 {
            print("✓ Data already seeded")
            return
        }

        print("🌱 Seeding initial data...")

        // Seed all categories
        let categories = seedCategories()

        // Seed subcategories for each category
        seedCoreFilmKnowledge(categories[0])
        seedDirectorsAndCreators(categories[1])
        seedGenres(categories[2])
        seedWorldCinema(categories[3])
        seedAwardsAndRecognition(categories[4])
        seedFilmCraft(categories[5])
        seedMovieEras(categories[6])
        seedActorsAndPerformances(categories[7])
        seedFranchisesAndSeries(categories[8])

        try? context.save()
        print("✓ Data seeding complete")
    }

    // MARK: - Category Seeding

    private func seedCategories() -> [CategoryModel] {
        let categoryData: [(String, String, String?, String, Double, Double, Double)] = [
            ("Core Film Knowledge", "Essential movie knowledge every film buff needs", nil, "film.stack", 0.95, 0.70, 0.25),
            ("Directors and Creators", "The visionaries behind the camera", nil, "person.2", 0.55, 0.35, 0.85),
            ("Genres", "Explore every style of storytelling", nil, "rectangle.grid.2x2", 0.25, 0.60, 0.98),
            ("World Cinema", "Films from around the globe", nil, "globe", 0.98, 0.55, 0.40),
            ("Awards and Recognition", "Celebrating cinematic excellence", nil, "trophy", 0.95, 0.75, 0.20),
            ("Film Craft and Behind the Scenes", "The art and technique of filmmaking", nil, "video", 0.20, 0.70, 0.45),
            ("Movie Eras", "Journey through cinema history", nil, "clock", 0.25, 0.70, 0.70),
            ("Actors and Performances", "The stars who bring stories to life", nil, "star.fill", 0.98, 0.40, 0.55),
            ("Franchises and Series", "Iconic film series and universes", nil, "film", 0.30, 0.55, 0.98)
        ]

        return categoryData.enumerated().map { index, data in
            let category = CategoryModel(
                title: data.0,
                subtitle: data.1,
                tag: data.2 ?? "",
                iconName: data.3,
                colorRed: data.4,
                colorGreen: data.5,
                colorBlue: data.6,
                displayOrder: index
            )
            context.insert(category)
            return category
        }
    }

    // MARK: - Core Film Knowledge

    private func seedCoreFilmKnowledge(_ category: CategoryModel) {
        let subCategories = [
            ("Film History Basics", "Foundation of cinema from its origins to today"),
            ("Famous Films Everyone Should Know", "Essential viewing for every movie lover"),
            ("Movie Quotes and Moments", "Iconic lines and unforgettable scenes"),
            ("Box Office Hits", "The biggest commercial successes in film"),
            ("Award Winners", "Critically acclaimed masterpieces"),
            ("Cult Classics", "Beloved films with devoted followings")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Directors and Creators

    private func seedDirectorsAndCreators(_ category: CategoryModel) {
        let subCategories = [
            ("Famous Directors", "Legendary filmmakers who shaped cinema"),
            ("Indie Filmmakers", "Independent voices in film"),
            ("Director Filmographies", "Complete works of master directors"),
            ("Signature Styles", "Recognizable techniques and aesthetics"),
            ("First Films vs Breakthrough Films", "Career-defining moments")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Genres

    private func seedGenres(_ category: CategoryModel) {
        let subCategories = [
            ("Action", "Thrills, stunts, and adrenaline"),
            ("Comedy", "Films that make us laugh"),
            ("Drama", "Emotional storytelling at its finest"),
            ("Horror", "Spine-tingling terror"),
            ("Sci-Fi", "Imagination and technology collide"),
            ("Romance", "Love stories on screen"),
            ("Thriller", "Suspense and tension"),
            ("Animation", "Bringing imagination to life")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - World Cinema

    private func seedWorldCinema(_ category: CategoryModel) {
        let subCategories = [
            ("Hollywood", "The American film industry"),
            ("European Cinema", "Films from across Europe"),
            ("Asian Cinema", "East and South Asian filmmaking"),
            ("Australian Cinema", "Films from Down Under"),
            ("Foreign Language Hits", "International crossover successes"),
            ("International Award Winners", "Global recognition for excellence")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Awards and Recognition

    private func seedAwardsAndRecognition(_ category: CategoryModel) {
        let subCategories = [
            ("Academy Awards (Oscars)", "Hollywood's biggest night"),
            ("Cannes Film Festival", "Prestige on the French Riviera"),
            ("Golden Globes", "Recognizing film and television"),
            ("BAFTAs", "British Academy honors"),
            ("Palme d'Or Winners", "Cannes' highest honor"),
            ("Best Picture Winners by Year", "Oscar's top prize through history")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Film Craft and Behind the Scenes

    private func seedFilmCraft(_ category: CategoryModel) {
        let subCategories = [
            ("Cinematography", "The art of capturing images"),
            ("Screenwriting", "Crafting stories for the screen"),
            ("Editing", "Shaping the final cut"),
            ("Sound and Music", "Audio magic in cinema"),
            ("Visual Effects", "Digital wizardry"),
            ("Practical Effects", "Real-world movie magic")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Movie Eras

    private func seedMovieEras(_ category: CategoryModel) {
        let subCategories = [
            ("Silent Era", "Before the talkies"),
            ("Golden Age of Hollywood", "The studio system's peak"),
            ("1970s New Hollywood", "A creative revolution"),
            ("1990s Blockbusters", "Event movies and spectacle"),
            ("2000s Franchises", "The rise of cinematic universes"),
            ("Modern Streaming Era", "Cinema in the digital age")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Actors and Performances

    private func seedActorsAndPerformances(_ category: CategoryModel) {
        let subCategories = [
            ("Iconic Performances", "Unforgettable roles in cinema"),
            ("Actor Filmographies", "Complete works of legendary performers"),
            ("Breakout Roles", "Star-making performances"),
            ("Method Actors", "Total immersion in character"),
            ("On-Screen Duos", "Legendary partnerships")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Franchises and Series

    private func seedFranchisesAndSeries(_ category: CategoryModel) {
        let subCategories = [
            ("Star Wars", "A galaxy far, far away"),
            ("Marvel", "Earth's mightiest heroes"),
            ("Harry Potter", "The Wizarding World"),
            ("Lord of the Rings", "Middle-earth adventures"),
            ("James Bond", "007's legendary missions"),
            ("Fast and Furious", "Family and fast cars")
        ]
        seedSubcategories(subCategories, for: category)
    }

    // MARK: - Helper Methods

    private func seedSubcategories(_ subCategories: [(String, String)], for category: CategoryModel) {
        for (index, (title, description)) in subCategories.enumerated() {
            let subCategory = SubCategory(
                title: title,
                descriptionText: description,
                displayOrder: index
            )
            subCategory.parentCategory = category
            context.insert(subCategory)

            // Add placeholder challenge
            let challenge = Challenge(
                questionText: "This lesson is coming soon. Stay tuned!",
                questionType: .trueFalse,
                correctAnswer: "true",
                wrongAnswers: nil,
                explanation: "More content will be added in future updates.",
                difficulty: .easy
            )
            challenge.subCategory = subCategory
            context.insert(challenge)
        }
    }
}
