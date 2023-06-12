//
//  SocialButton.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 4.06.23.
//

import SwiftUI

struct SocialButton: View {
    let title: String
    let color: Color
    @Binding var buttonAnimation: Bool
    let buttonTag: Int

    var body: some View {
        Button(action: {
            handleButtonTap(buttonTag)
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                  RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                )
                .opacity(buttonAnimation ? 1.0 : 0.0)
        }
        .padding()
    }

    func handleButtonTap(_ tag: Int) {
        switch tag {
        case 1:
           print("1")
        case 2:
          print("2")
        case 3:
          print("3")
        default:
            break
        }
    }
}

