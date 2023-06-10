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
    @State private var isEditFriendViewPresented = false
    @State private var isCustomRectangleVisible = false
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

  var groupedFriends: [(String, [Friend])] {
      Dictionary(grouping: filteredFriends) { friend in
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM"
          return dateFormatter.string(from: friend.date)
      }
      .sorted(by: { $0.key < $1.key })
  }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                    VStack {
                        ForEach(groupedFriends, id: \.0) { month, friends in
                            HStack {
                              TimeLineView(month: month)
                                  .padding(.leading, 16)
                                  .padding(.bottom)
                                  .padding(.top, 16)
                                  .onTapGesture {
                                    withAnimation(.easeIn(duration: 0.3)) {
                                          isCustomRectangleVisible.toggle()
                                      }
                                  }
                                VStack {
                                    ForEach(friends.sorted(by: { $0.daysUntilBirthday < $1.daysUntilBirthday })) { friend in
                                        FriendCell(friend: friend)
                                        .padding(.trailing, 16)
                                        .padding(.bottom)
                                        .padding(.top, 16)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            Button(action: {
                isAddViewShow.toggle()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.title)
                    .frame(width: 54, height: 54)
                    .background(Color.green)
                    .cornerRadius(30)
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
        .onTapGesture {
            hideKeyboard()
        }
        .overlay(
            Group {
                if isCustomRectangleVisible {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isCustomRectangleVisible = false
                        }

                    VStack {
                        Image("1")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                        Text("Означает номер месяца рождения")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                    }

                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                }
            }
        )
    }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FriendsView()
  }
}
