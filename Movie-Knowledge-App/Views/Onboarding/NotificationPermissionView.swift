//
//  NotificationPermissionView.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    var onContinue: () -> Void
    var onSkip: () -> Void

    @State private var showContent = false
    @State private var selectedTime = Date()
    @State private var notificationsEnabled = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Header
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.orange)
                }
                .padding(.bottom, 8)

                Text("Stay on track")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Get a daily reminder to keep your streak alive")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .opacity(showContent ? 1.0 : 0.0)

            Spacer()

            // Notification toggle and time picker
            VStack(spacing: 20) {
                // Enable toggle
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily reminders")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)

                        Text("We'll remind you to practice")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Toggle("", isOn: $notificationsEnabled)
                        .labelsHidden()
                        .tint(.blue)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)

                // Time picker (only visible when enabled)
                if notificationsEnabled {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Reminder time")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)

                            Text("When should we notify you?")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        DatePicker(
                            "",
                            selection: $selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal, 24)
            .opacity(showContent ? 1.0 : 0.0)
            .offset(y: showContent ? 0 : 20)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: notificationsEnabled)

            Spacer()
            Spacer()

            // CTA Buttons
            VStack(spacing: 12) {
                Button(action: {
                    HapticManager.shared.medium()
                    if notificationsEnabled {
                        requestNotificationPermission()
                    }
                    onContinue()
                }) {
                    Text(notificationsEnabled ? "Enable Notifications" : "Continue")
                        .depthButtonLabel(font: .system(size: 18, weight: .semibold), verticalPadding: 18)
                }
                .buttonStyle(DepthButtonStyle(cornerRadius: 16))

                Button(action: {
                    onSkip()
                }) {
                    Text("Skip for now")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(showContent ? 1.0 : 0.0)
        }
        .onAppear {
            // Set default time to 9:00 AM
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 9
            components.minute = 0
            selectedTime = Calendar.current.date(from: components) ?? Date()

            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                scheduleNotification()
            }
        }
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to learn!"
        content.body = "Keep your streak alive with today's movie trivia."
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

#Preview {
    NotificationPermissionView(
        onContinue: {},
        onSkip: {}
    )
}
