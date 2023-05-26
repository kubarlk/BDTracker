//
//  EditFriendView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 19.05.23.
//

import SwiftUI

struct EditFriendView: View {

  let friend: Friend
    var body: some View {

        VStack {
          Text(friend.name)
        }
      
    }
}

