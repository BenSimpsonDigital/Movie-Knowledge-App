//
//  ProgressRing.swift
//  Movie-Knowledge-App
//
//  Created by Ben Simpson on 29/1/2026.
//

import SwiftUI

struct ProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let color: Color
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)

            // Progress text
            Text("\(Int(progress * 100))%")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressRing(progress: 0.3, color: .blue, lineWidth: 3)
            .frame(width: 50, height: 50)

        ProgressRing(progress: 0.7, color: .green, lineWidth: 3)
            .frame(width: 50, height: 50)

        ProgressRing(progress: 1.0, color: .orange, lineWidth: 3)
            .frame(width: 50, height: 50)
    }
    .padding()
}
