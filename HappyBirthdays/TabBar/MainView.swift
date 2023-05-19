//
//  MainView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 19.05.23.
//

import SwiftUI

struct MainView: View {
  @State private var selectedTab: Tab = .contacts

  var body: some View {
    VStack(spacing: 0) {
      // Display the main view based on the selected tab
      switch selectedTab {
      case .contacts:
        FriendsView()
         
      case .wishes:
        Text("Wishes View")
      case .settings:
        Text("Settings View")
      }
      Spacer()
      // Display the TabBar
      TabBar(selectedTab: $selectedTab)
    }
    .ignoresSafeArea(.keyboard) // Игнорировать клавиатуру на всем экране
  }
}


struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
