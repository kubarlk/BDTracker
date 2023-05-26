//
//  SettingsView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 26.05.23.
//

import SwiftUI

struct SettingsView: View {
 
    var body: some View {
        VStack {
            Text("Настройки")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            ScrollView {
                VStack(spacing: 16) {
                    ButtonRowView(title: "Contacts", imageName: "person", color: .blue) {

                    }
                    ButtonRowView(title: "VK", imageName: "square.and.arrow.up", color: .blue) {
                        // Действие при нажатии на кнопку "VK"
                    }
                    ButtonRowView(title: "Facebook", imageName: "hand.thumbsup", color: .blue) {
                        // Действие при нажатии на кнопку "Facebook"
                    }
                    ButtonRowView(title: "Delete contacts", imageName: "trash", color: .red) {
                        // Действие при нажатии на кнопку "Delete contacts"
                    }
                }
                .padding()
            }
        }
    }
}

struct ButtonRowView: View {
    let title: String
    let imageName: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.trailing, 8)

                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
