//
//  FriendCell.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 14.05.23.
//

import SwiftUI

struct FriendCell: View {
  let friend: Friend

  var body: some View {
    HStack {
      Image(uiImage: UIImage(data: friend.avatar) ?? UIImage(named: "1")!)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 80, height: 80)
          .clipShape(Circle())


      VStack(alignment: .leading) {
        Text(friend.name)
          .font(.title)
          .fontWeight(.bold)
        Text("День рождения: \(friend.birthday)")
          .font(.subheadline)
        Text("Turns: \(friend.turns)")
          .font(.caption)
          .foregroundColor(.secondary)
        Spacer()
      }
      .padding(.leading, 10)

      Spacer()

      ZStack {
        Circle()
          .fill(friend.daysUntilBirthday > 10 ? Color.green : Color.red)
          .frame(width: 30, height: 30)
        Text("\(friend.daysUntilBirthday)")
          .foregroundColor(.white)
          .font(.caption)
      }

    }
    .padding()
    .background(Color.gray.opacity(0.2))
    .cornerRadius(10)
  }
}
