//
//  TabBar.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 19.05.23.
//

import SwiftUI

struct TabBar: View {
  @Binding var selectedTab: Tab

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(Color.white)
        .shadow(color: Color.gray.opacity(0.4), radius: 20, x: 0, y: 20)

      TabsLayoutView(selectedTab: $selectedTab)
    }
    .frame(height: 70, alignment: .center)
  }
}

fileprivate struct TabsLayoutView: View {
  @Binding var selectedTab: Tab
  @Namespace var namespace

  var body: some View {
    HStack {
      Spacer(minLength: 0)

      ForEach(Tab.allCases) { tab in
        TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
          .frame(width: 65, height: 65, alignment: .center)

        Spacer(minLength: 0)
      }
    }
  }
}

private struct TabButton: View {
  let tab: Tab
  @Binding var selectedTab: Tab
  var namespace: Namespace.ID

  var body: some View {
    Button(action: {
      withAnimation {
        selectedTab = tab
      }
    }) {
      ZStack {
        if isSelected {
          Circle()
            .foregroundColor(.green.opacity(0.8))
            .background {
              Circle()
                .stroke(lineWidth: 8)
                .foregroundColor(Color.green)
            }
            .offset(y: -40)
            .matchedGeometryEffect(id: "Selected Tab", in: namespace)
            .animation(.spring(), value: selectedTab)
        }

        Image(systemName: tab.icon)
          .font(.system(size: 23, weight: .semibold, design: .rounded))
          .foregroundColor(isSelected ? .white : .gray)
          .scaleEffect(isSelected ? 1 : 0.8)
          .offset(y: isSelected ? -40 : 0)
          .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
      }
    }
    .buttonStyle(.plain)
  }

  private var isSelected: Bool {
    selectedTab == tab
  }
}

