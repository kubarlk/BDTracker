//
//  SettingsView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 26.05.23.
//

import SwiftUI
import Contacts

struct SettingsView: View {
  @State private var buttonAnimation = false

  var body: some View {
    VStack {
      Text("Настройки")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding()

      // Добавляем баннер подписок
      SubscriptionBanner()
        .padding(.top, 16)
      
      ScrollView(showsIndicators: false) {
        SocialSection(buttonAnimation: $buttonAnimation)
      }
    }
    .onAppear {
      buttonAnimation.toggle()
    }
  }
}

//MARK: Sync contacts from iPhone
private extension SettingsView {
   func fetchContactsAndSaveToDatabase() {
      let store = CNContactStore()
      store.requestAccess(for: .contacts) { granted, error in
          guard granted else {
              print("Access to contacts not granted.")
              return
          }

          if let error = error {
              print("Error requesting access to contacts: \(error.localizedDescription)")
              return
          }

          let keysToFetch: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                                                CNContactBirthdayKey as CNKeyDescriptor]

          DispatchQueue.global().async {
              do {
                  try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keysToFetch)) { contact, stop in
                      guard let fullName = CNContactFormatter.string(from: contact, style: .fullName) else {
                          return
                      }
                      if let birthday = contact.birthday?.date {
                          let dateFormatter = DateFormatter()
                          dateFormatter.dateFormat = "dd.MM.yyyy"
                          let birthdayString = dateFormatter.string(from: birthday)
                          print("Full Name: \(fullName)")
                          print("Birthday: \(birthdayString)")
                          print("--------------------")
                      }
                  }
              } catch {
                  print("Error fetching contacts: \(error.localizedDescription)")
              }
          }
      }
  }
}

//MARK: Sync contacts from social media (VK, Facebook, etc.. )


struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

