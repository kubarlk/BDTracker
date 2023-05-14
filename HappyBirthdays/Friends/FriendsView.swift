//
//  FriendsView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 14.05.23.
//

import SwiftUI
import PhotosUI

struct FriendsView: View {
  @State private var searchText = ""
  @State private var isAddViewShow = false
  @State private var shouldUpdateFriends = false

  @State var friends: [Friend] = []

  init() {
    friends = DatabaseService.shared.fetchFriends()
  }

  var filteredFriends: [Friend] {
    if searchText.isEmpty {
      return friends
    } else {
      return friends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
  }

  var groupedFriends: [String: [Friend]] {
    Dictionary(grouping: filteredFriends) { friend in
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMMM"
      return dateFormatter.string(from: friend.date)
    }
  }

  var body: some View {
    VStack {
      Text("Ваши друзья")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding()

      HStack {
        TextField("Поиск по имени", text: $searchText)
          .padding()
      }
      .background(Color.gray.opacity(0.2))
      .cornerRadius(10)
      .padding()

      ScrollView(showsIndicators: false) {
        ForEach(groupedFriends.sorted(by: { $0.key < $1.key }), id: \.key) { month, friends in
          Section(header: Text(month).font(.headline)) {
            ForEach(friends.sorted(by: { $0.daysUntilBirthday < $1.daysUntilBirthday })) { friend in
              FriendCell(friend: friend)
                .padding()
            }
          }
        }
      }

      Button(action: {
        isAddViewShow.toggle()
      }) {
        Text("Добавить друга")
          .foregroundColor(.white)
          .font(.headline)
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
      .padding()
    }
    .onAppear {
      friends = DatabaseService.shared.fetchFriends()
    }
    .sheet(isPresented: $isAddViewShow, onDismiss: {
                if shouldUpdateFriends {
                    friends = DatabaseService.shared.fetchFriends()
                    shouldUpdateFriends = false
                }
            }) {
                AddFriendView(shouldUpdateFriends: $shouldUpdateFriends)
            }
  }
  func createDate(day: Int, month: Int, year: Int) -> Date {
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.day = day
    dateComponents.month = month
    dateComponents.year = year
    return calendar.date(from: dateComponents)!
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FriendsView()
  }
}
