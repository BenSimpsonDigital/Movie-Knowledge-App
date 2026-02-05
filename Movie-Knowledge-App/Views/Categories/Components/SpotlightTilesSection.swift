//
//  SpotlightTilesSection.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct SpotlightTilesSection: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context
    
    let categories: [CategoryModel]
    let onCategorySelected: (CategoryModel) -> Void
    
    // MARK: - Computed Properties
    
    private var continueCategory: CategoryModel? {
        // Priority 1: Last played category
        if let lastPlayed = appState.lastPlayedCategory {
            return lastPlayed
        }
        // Priority 2: Suggested category ("The Essentials")
        return categories.first { $0.title == "The Essentials" }
            ?? categories.first
    }
    
    private var isLastPlayed: Bool {
        appState.lastPlayedCategory != nil
    }
    
    private var directorSpotlight: DirectorSpotlight? {
        DataSeeder.currentDirectorSpotlight()
    }
    
    private var directorsCategory: CategoryModel? {
        categories.first { $0.title == "Directors and Creators" }
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            ContinueOnTile(
                category: continueCategory,
                isLastPlayed: isLastPlayed,
                onTap: {
                    if let cat = continueCategory {
                        onCategorySelected(cat)
                    }
                }
            )
            
            DirectorSpotlightTile(
                spotlight: directorSpotlight,
                category: directorsCategory,
                onTap: {
                    if let cat = directorsCategory {
                        onCategorySelected(cat)
                    }
                }
            )
        }
    }
}

#Preview {
    let category1 = CategoryModel(
        title: "Core Film Knowledge",
        subtitle: "Essential movie fundamentals",
        tag: "START",
        iconName: "film.stack",
        colorRed: 0.75,
        colorGreen: 0.68,
        colorBlue: 0.58,
        displayOrder: 0
    )
    
    let category2 = CategoryModel(
        title: "Directors and Creators",
        subtitle: "Master filmmakers and visionaries",
        tag: nil,
        iconName: "sparkles",
        colorRed: 0.72,
        colorGreen: 0.65,
        colorBlue: 0.60,
        displayOrder: 1
    )
    
    SpotlightTilesSection(
        categories: [category1, category2],
        onCategorySelected: { _ in }
    )
    .environment(AppState())
    .padding(24)
    .background(DesignSystem.Colors.screenBackground)
}
