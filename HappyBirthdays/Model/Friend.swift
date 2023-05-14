//
//  Friend.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 14.05.23.
//

import Foundation

struct Friend: Identifiable {
  let id: UUID
  let name: String
  let avatar: Data
  let birthday: String
  let daysUntilBirthday: Int
  let turns: Int
  let date: Date

  init(id: UUID = UUID(), name: String, avatar: Data, birthday: String, daysUntilBirthday: Int, turns: Int, date: Date) {
    self.id = id
    self.name = name
    self.avatar = avatar
    self.birthday = birthday
    self.daysUntilBirthday = daysUntilBirthday
    self.turns = turns
    self.date = date
  }
}


