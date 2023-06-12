//
//  CustomAlert.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 12.06.23.
//

import SwiftUI

struct CustomAlert: View {
  @Binding var isPresented: Bool
  let title: String
  let message: String

  var body: some View {
    ZStack {
      Color.clear
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
          // Закрываем алерт при нажатии на задний фон
          isPresented = false
        }

      VStack(spacing: 16) {
        Text(title)
          .font(.headline)
          .padding(.top, 20)

        Text(message)
          .font(.body)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 20)

        Button(action: {
          // Закрываем алерт при нажатии на кнопку
          isPresented = false
        }) {
          Text("OK")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      }
      .frame(width: 280)
      .background(Color.white)
      .cornerRadius(20)
      .shadow(radius: 10)
      .opacity(isPresented ? 1 : 0) // Show or hide the alert based on isPresented
      .scaleEffect(isPresented ? 1 : 0.5) // Scale the alert when presenting
      .onAppear {
        withAnimation(.spring()) { // Apply the spring animation
          isPresented = true
        }
      }
    }
  }
}
