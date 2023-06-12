//
//  FriendCell.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 14.05.23.
//

import SwiftUI

struct FriendCell: View {

  let friend: Friend
  @State private var isEditFriendViewPresented = false

  var body: some View {
    VStack {
      HStack {
        Image(uiImage: UIImage(data: friend.avatar) ?? UIImage(named: "1")!)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 80, height: 80)
          .clipShape(Circle())
        VStack(alignment: .leading) {
          Text(friend.name)
            .fontWeight(.semibold)
          Spacer()
          Text("\(friend.birthday)")
            .font(.subheadline)
          Spacer()
          Text("Исполняется: \(friend.turns)")
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
    }
    .background(
      RoundedRectangle(cornerRadius: 15)
        .stroke(Color.white.opacity(0.2), lineWidth: 1)
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    )
    .onTapGesture {
      isEditFriendViewPresented.toggle()
    }
    .sheet(isPresented: $isEditFriendViewPresented) {
      EditFriendView(friend: friend)
    }
  }
}
