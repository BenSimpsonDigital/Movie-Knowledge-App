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
            let schema = Schema([
                UserProfile.self,
                CategoryModel.self,
                SubCategory.self,
                Challenge.self,
                CategoryProgress.self,
                Badge.self,
                DailyLessonRecord.self,
                UserPreferences.self,
                Movie.self,
                Director.self
            ])
            
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: config)

            // Seed data on first launch
            let context = ModelContext(container)
            let seeder = DataSeeder(context: context)
            seeder.seedDataIfNeeded()

        } catch {
            print("❌ ModelContainer Error: \(error)")
            print("❌ Error Details: \(String(describing: error))")
            
            // If schema migration fails, delete the old store and try again
            print("⚠️ Attempting to reset data store due to schema change...")
            do {
                let schema = Schema([
                    UserProfile.self,
                    CategoryModel.self,
                    SubCategory.self,
                    Challenge.self,
                    CategoryProgress.self,
                    Badge.self,
                    DailyLessonRecord.self,
                    UserPreferences.self,
                    Movie.self,
                    Director.self
                ])
                
                // Delete the old store file
                let url = URL.applicationSupportDirectory.appending(path: "default.store")
                try? FileManager.default.removeItem(at: url)
                
                let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                container = try ModelContainer(for: schema, configurations: config)
                
                // Seed data after reset
                let context = ModelContext(container)
                let seeder = DataSeeder(context: context)
                seeder.seedDataIfNeeded()
                
                print("✅ Data store reset successful")
            } catch {
                fatalError("Failed to initialize ModelContainer even after reset: \(error)")
            }
         }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
