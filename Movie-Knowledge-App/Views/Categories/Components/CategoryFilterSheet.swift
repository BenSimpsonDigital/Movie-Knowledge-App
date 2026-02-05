//
//  CategoryFilterSheet.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 4/2/2026.
//

import SwiftUI

struct CategoryFilterSheet: View {
    @Bindable var viewModel: CategoryFilterViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    screenTitle

                    // Completion Status Section
                    filterSection(
                        title: "Completion Status",
                        options: CompletionStatus.allCases,
                        selection: $viewModel.completionFilter
                    )

                    // Content Type Section
                    filterSection(
                        title: "Content Type",
                        options: ContentTypeFilter.allCases,
                        selection: $viewModel.contentTypeFilter
                    )

                    // Region Section
                    filterSection(
                        title: "Region",
                        options: RegionFilter.allCases,
                        selection: $viewModel.regionFilter
                    )

                    // Lesson Count Section
                    filterSection(
                        title: "Number of Lessons",
                        options: LessonCountFilter.allCases,
                        selection: $viewModel.lessonCountFilter
                    )

                    // Difficulty Section
                    filterSection(
                        title: "Difficulty Level",
                        options: DifficultyFilter.allCases,
                        selection: $viewModel.difficultyFilter
                    )
                }
                .padding(DesignSystem.Spacing.xl)
            }
            .background(DesignSystem.Colors.screenBackground)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if viewModel.activeFilterCount > 0 {
                        Button("Clear All") {
                            withAnimation(DesignSystem.Animations.smooth) {
                                viewModel.clearAllFilters()
                            }
                            HapticManager.shared.light()
                        }
                        .foregroundStyle(DesignSystem.Colors.accent)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        viewModel.persistFilters()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(DesignSystem.Colors.accent)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var screenTitle: some View {
        Text("Filters")
            .font(DesignSystem.Typography.viewTitle())
            .foregroundStyle(DesignSystem.Colors.textPrimary)
            .padding(.leading, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, DesignSystem.Spacing.xxs)
    }

    // MARK: - Filter Section Builder

    private func filterSection<T: RawRepresentable & CaseIterable & Hashable>(
        title: String,
        options: [T],
        selection: Binding<T>
    ) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(DesignSystem.Typography.heading())
                .foregroundStyle(DesignSystem.Colors.textPrimary)

            // Horizontal scrolling chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        FilterChip(
                            title: displayName(for: option),
                            isSelected: selection.wrappedValue == option,
                            action: {
                                withAnimation(DesignSystem.Animations.snappy) {
                                    selection.wrappedValue = option
                                }
                                HapticManager.shared.light()
                            }
                        )
                    }
                }
            }
        }
    }

    private func displayName<T: RawRepresentable>(for option: T) -> String where T.RawValue == String {
        if let completion = option as? CompletionStatus {
            return completion.displayName
        } else if let contentType = option as? ContentTypeFilter {
            return contentType.displayName
        } else if let region = option as? RegionFilter {
            return region.displayName
        } else if let lessonCount = option as? LessonCountFilter {
            return lessonCount.displayName
        } else if let difficulty = option as? DifficultyFilter {
            return difficulty.displayName
        }
        return option.rawValue
    }
}

#Preview {
    CategoryFilterSheet(viewModel: CategoryFilterViewModel())
}
