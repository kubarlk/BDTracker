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
      switch selectedTab {
      case .contacts:
        FriendsView()
         
      case .wishes:
        Text("Wishes View")
      case .settings:
        SettingsView()
      }
      Spacer()
      TabBar(selectedTab: $selectedTab)
    }
    .ignoresSafeArea(.keyboard)
  }
}


struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
