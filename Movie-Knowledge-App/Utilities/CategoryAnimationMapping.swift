//
//  CategoryAnimationMapping.swift
//  Movie-Knowledge-App
//
//  Created by Claude on 2/2/2026.
//

import Foundation
import SwiftData

enum CategoryAnimationMapping {

    /// Maps each category to a Lottie animation file.
    /// Currently using popcorn animation for all categories.
    static func animationName(for category: CategoryModel) -> String {
        return "popcorn-animation-1"
    }
}
