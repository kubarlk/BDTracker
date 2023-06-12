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

            VStack {
                SocialButton(title: "Facebook", color: .green, buttonAnimation: $buttonAnimation, buttonTag: 1)
                    .animation(.easeInOut(duration: 0.5).delay(0.2))


                SocialButton(title: "iPhone", color: .green, buttonAnimation: $buttonAnimation, buttonTag: 2)
                    .animation(.easeInOut(duration: 0.5).delay(0.4))


                SocialButton(title: "VK", color: .green, buttonAnimation: $buttonAnimation, buttonTag: 3)
                    .animation(.easeInOut(duration: 0.5).delay(0.6))

            }

            .background(
              RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .background(Color.white.opacity(0.05))
                .cornerRadius(15)
            )
            .opacity(buttonAnimation ? 1.0 : 0.0)
        }
        .padding(.horizontal)
    }
}


