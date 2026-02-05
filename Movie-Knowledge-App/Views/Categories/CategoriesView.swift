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
    }
}

#Preview {
    CategoriesView()
        .environment(AppState())
        .modelContainer(for: [CategoryModel.self])
}
