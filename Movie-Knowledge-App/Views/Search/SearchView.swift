//
//  SearchView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState

    @State private var searchText = ""
    @State private var searchResults: [CategoryModel] = []

    var body: some View {
        ZStack {
            // Background
            DesignSystem.Colors.screenBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundStyle(.secondary)

                    TextField("Search movies, directors, categories...", text: $searchText)
                        .font(.system(size: 16))
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(DesignSystem.Colors.cardBackground)
                )
                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                .padding(.horizontal, 24)
                .padding(.top, 16)

                if searchText.isEmpty {
                    // Empty state / suggestions
                    VStack(spacing: 24) {
                        Spacer()

                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary.opacity(0.5))

                        VStack(spacing: 8) {
                            Text("Discover movie knowledge")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)

                            Text("Search for categories, movies, directors, and more")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        Spacer()
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else if searchResults.isEmpty {
                    // No results
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary.opacity(0.5))

                        Text("No results for \"\(searchText)\"")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.primary)

                        Text("Try a different search term")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)

                        Spacer()
                        Spacer()
                    }
                } else {
                    // Search results
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults) { category in
                                SearchResultRow(category: category)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: searchText) { _, newValue in
            performSearch(query: newValue)
        }
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        let lowercasedQuery = query.lowercased()

        // Search categories
        let categoryDescriptor = FetchDescriptor<CategoryModel>()
        if let categories = try? context.fetch(categoryDescriptor) {
            searchResults = categories.filter { category in
                category.title.lowercased().contains(lowercasedQuery) ||
                category.subtitle.lowercased().contains(lowercasedQuery)
            }
        }
    }
}

// MARK: - Search Result Row

struct SearchResultRow: View {
    let category: CategoryModel

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: category.iconName ?? "film")
                .font(.system(size: 24))
                .foregroundStyle(category.accentColor)
                .frame(width: 50, height: 50)
                .background(category.accentColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(category.subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(DesignSystem.Colors.cardBackground)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .environment(AppState())
}
