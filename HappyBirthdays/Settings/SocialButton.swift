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
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                        .shadow(color: color, radius: 10, x: 0, y: 5)
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

