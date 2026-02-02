//
//  Movie_Knowledge_AppApp.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

@main
struct Movie_Knowledge_AppApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: UserProfile.self,
                CategoryModel.self,
                SubCategory.self,
                Challenge.self,
                CategoryProgress.self,
                Badge.self,
                DailyLessonRecord.self,
                UserPreferences.self,
                Movie.self,
                Director.self
            )

            // Seed data on first launch
            let context = ModelContext(container)
            let seeder = DataSeeder(context: context)
            seeder.seedDataIfNeeded()

        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
