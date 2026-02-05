//
//  ContentView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var appState = AppState()

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                NavigationStack {
                    CategoriesView()
                }
            } else {
                OnboardingContainerView()
            }
        }
        .environment(appState)
        .onAppear {
            // Load user data on app launch
            appState.loadUserProfile(from: context)
            appState.loadUserPreferences(from: context)
            appState.initializeServices(context: context)
            appState.loadLastPlayedContent(from: context)
        }
    }
}

#Preview {
    ContentView()
}
