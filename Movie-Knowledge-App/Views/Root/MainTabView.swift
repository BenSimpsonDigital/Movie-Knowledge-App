//
//  MainTabView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//  Minimal, clean tab bar design
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @State private var selectedTab: AppTab = .home

    private let tabs: [AppTab] = [.home, .categories, .profile]

    var body: some View {
        @Bindable var appState = appState

        GeometryReader { geometry in
            HStack(spacing: 0) {
                NavigationStack {
                    HomeView()
                }
                .frame(width: geometry.size.width)

                NavigationStack {
                    CategoriesView()
                }
                .frame(width: geometry.size.width)

                NavigationStack {
                    ProfileView()
                }
                .frame(width: geometry.size.width)
            }
            .offset(x: -CGFloat(selectedTabIndex) * geometry.size.width)
            .animation(.spring(response: 0.35, dampingFraction: 0.86), value: selectedTab)
        }
        .background(DesignSystem.Colors.screenBackground.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selectedTab: $selectedTab, onTabSelected: selectTab)
        }
        .ignoresSafeArea(.keyboard)
    }

    private var selectedTabIndex: Int {
        tabs.firstIndex(of: selectedTab) ?? 0
    }

    private func selectTab(_ newTab: AppTab) {
        HapticManager.shared.light()
        appState.selectedTab = newTab
        selectedTab = newTab
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    let onTabSelected: (AppTab) -> Void

    private let tabs: [AppTab] = [.home, .categories, .profile]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    onTabSelected(tab)
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.lg)
        .padding(.top, DesignSystem.Spacing.sm)
        .padding(.bottom, DesignSystem.Spacing.sm)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(DesignSystem.Colors.cardBackground)
                .ignoresSafeArea(.container, edges: .bottom)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(DesignSystem.Colors.borderDefault)
                .frame(height: 1)
        }
    }
}

// MARK: - Tab Bar Button

struct TabBarButton: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIconName : tab.iconName)
                    .font(.system(size: 20, weight: isSelected ? .medium : .regular))
                    .foregroundStyle(isSelected
                        ? DesignSystem.Colors.tabAccent
                        : DesignSystem.Colors.textTertiary)
                    .frame(height: 24)

                Text(tab.displayName)
                    .font(.system(size: 10, weight: isSelected ? .medium : .regular, design: .default))
                    .foregroundStyle(isSelected
                        ? DesignSystem.Colors.tabAccent
                        : DesignSystem.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - AppTab Extension for Selected Icons

extension AppTab {
    /// Solid icon for selected state
    var selectedIconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .categories:
            return "book.fill"
        case .profile:
            return "person.fill"
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
        .modelContainer(for: [UserProfile.self, CategoryModel.self])
}
