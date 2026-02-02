//
//  AppTab.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import Foundation

enum AppTab: String, CaseIterable {
    case home
    case categories
    case profile

    var displayName: String {
        switch self {
        case .home:
            return "Home"
        case .categories:
            return "Learn"
        case .profile:
            return "Profile"
        }
    }

    /// Outline icon for unselected state
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .categories:
            return "book"
        case .profile:
            return "person"
        }
    }
}
