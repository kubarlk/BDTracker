//
//  DatabaseService.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 14.05.23.
//

import CoreData
import UIKit

class DatabaseService {
  static let shared = DatabaseService()
  private init() {}

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "FriendDB")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error {
        fatalError("Unresolved error \(error)")
      }
    })
    return container
  }()

  func saveFriend(_ friend: Friend) {
    let context = persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "FriendEntity", in: context) else {
      return
    }
    let friendObject = NSManagedObject(entity: entity, insertInto: context)
    friendObject.setValue(friend.id, forKey: "id")
    friendObject.setValue(friend.name, forKey: "name")
    friendObject.setValue(friend.avatar, forKey: "avatar")
    friendObject.setValue(friend.birthday, forKey: "birthday")
    friendObject.setValue(friend.daysUntilBirthday, forKey: "daysUntilBirthday")
    friendObject.setValue(friend.turns, forKey: "turns")
    friendObject.setValue(friend.date, forKey: "date")

    do {
      try context.save()
      print("Saved \(friend)")
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func fetchFriends() -> [Friend] {
    let context = persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendEntity")
    request.returnsObjectsAsFaults = false

    do {
      let result = try context.fetch(request)
      var friends = [Friend]()

      for data in result as! [NSManagedObject] {
        let id = data.value(forKey: "id") as? UUID ?? UUID()
        let name = data.value(forKey: "name") as? String ?? ""
        let avatar = data.value(forKey: "avatar") as? Data ?? Data()
        let birthday = data.value(forKey: "birthday") as? String ?? ""
        let daysUntilBirthday = data.value(forKey: "daysUntilBirthday") as? Int ?? 0
        let turns = data.value(forKey: "turns") as? Int ?? 0
        let date = data.value(forKey: "date") as? Date ?? Date()

        let friend = Friend(id: id, name: name, avatar: avatar, birthday: birthday, daysUntilBirthday: daysUntilBirthday, turns: turns, date: date)
        friends.append(friend)
      }

      return friends
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return []
    }
  }

  func deleteFriend(_ friend: Friend) {
    let context = persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendEntity")
    request.predicate = NSPredicate(format: "id == %@", friend.id as CVarArg)

    do {
      let result = try context.fetch(request)
      if let objectToDelete = result.first as? NSManagedObject {
        context.delete(objectToDelete)
        try context.save()
        print("Deleted \(friend)")
      }
    } catch let error as NSError {
      print("Could not delete. \(error), \(error.userInfo)")
    }
  }

  func updateFriend(_ friend: Friend) {
    let context = persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendEntity")
    request.predicate = NSPredicate(format: "id == %@", friend.id as CVarArg)

    do {
      let result = try context.fetch(request)
      if let objectToUpdate = result.first as? NSManagedObject {
        objectToUpdate.setValue(friend.name, forKey: "name")
        objectToUpdate.setValue(friend.avatar, forKey: "avatar")
        objectToUpdate.setValue(friend.birthday, forKey: "birthday")
        objectToUpdate.setValue(friend.daysUntilBirthday, forKey: "daysUntilBirthday")
        objectToUpdate.setValue(friend.turns, forKey: "turns")
        objectToUpdate.setValue(friend.date, forKey: "date")

        try context.save()
        print("Updated \(friend)")
      }
    } catch let error as NSError {
      print("Could not update. \(error), \(error.userInfo)")
    }
  }

}
