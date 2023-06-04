//
//  SocialSection.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 4.06.23.
//

import SwiftUI

struct SocialSection: View {
    @Binding var buttonAnimation: Bool

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Социальные сети")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Spacer()
            }

            VStack(spacing: 16) {
                SocialButton(title: "Facebook", color: .green, buttonAnimation: $buttonAnimation, buttonTag: 1)
                    .animation(.easeInOut(duration: 0.5).delay(0.2))

                SocialButton(title: "iPhone", color: .green, buttonAnimation: $buttonAnimation, buttonTag: 2)
                    .animation(.easeInOut(duration: 0.5).delay(0.4))

                SocialButton(title: "VK", color: .green, buttonAnimation: $buttonAnimation, buttonTag: 3)
                    .animation(.easeInOut(duration: 0.5).delay(0.6))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.green.opacity(0.2))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            )
            .opacity(buttonAnimation ? 1.0 : 0.0)
        }
        .padding(.horizontal)
    }
}


