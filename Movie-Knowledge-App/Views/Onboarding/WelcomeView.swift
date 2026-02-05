//
//  WelcomeView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct WelcomeView: View {
    var onContinue: () -> Void

    @State private var showContent = false
    @State private var showButton = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Hero section
            VStack(spacing: 24) {
                // App icon/illustration
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.78, green: 0.86, blue: 0.94),
                                    Color(red: 0.68, green: 0.82, blue: 0.96)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)

                    Image(systemName: "film.stack.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                }
                .scaleEffect(showContent ? 1.0 : 0.5)
                .opacity(showContent ? 1.0 : 0.0)

                // Title
                VStack(spacing: 12) {
                    Text("Movie Knowledge")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.primary)

                    Text("Learn fascinating movie trivia,\nearn XP, and become a cinema expert!")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                .opacity(showContent ? 1.0 : 0.0)
                .offset(y: showContent ? 0 : 20)
            }
            .padding(.horizontal, 24)

            Spacer()

            // Features preview
            VStack(spacing: 16) {
                featureRow(icon: "sparkles", title: "Daily Quizzes", description: "Test your knowledge every day")
                featureRow(icon: "flame.fill", title: "Build Streaks", description: "Stay consistent and level up")
                featureRow(icon: "trophy.fill", title: "Earn Badges", description: "Collect achievements as you learn")
            }
            .padding(.horizontal, 32)
            .opacity(showContent ? 1.0 : 0.0)
            .offset(y: showContent ? 0 : 30)

            Spacer()

            // CTA Button
            Button(action: {
                HapticManager.shared.medium()
                onContinue()
            }) {
                Text("Get Started")
                    .depthButtonLabel(font: .system(size: 18, weight: .semibold), verticalPadding: 18)
            }
            .buttonStyle(DepthButtonStyle(cornerRadius: 16))
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(showButton ? 1.0 : 0.0)
            .offset(y: showButton ? 0 : 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.6)) {
                showButton = true
            }
        }
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
