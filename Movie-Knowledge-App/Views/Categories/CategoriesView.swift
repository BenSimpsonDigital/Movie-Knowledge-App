//
//  CategoriesView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var context

    var body: some View {
        ExpandableCategoryListView()
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: Binding(
                get: { appState.activeCategory != nil },
                set: { if !$0 { appState.activeCategory = nil } }
            )) {
                if let category = appState.activeCategory {
                    SubCategoryListView(category: category)
                }
            }
    }
}

#Preview {
    CategoriesView()
        .environment(AppState())
        .modelContainer(for: [CategoryModel.self])
}
