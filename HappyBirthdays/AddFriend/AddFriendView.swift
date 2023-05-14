//
//  AddFriendView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 14.05.23.
//

import SwiftUI

struct AddFriendView: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var shouldUpdateFriends: Bool
  @State private var name: String = ""
  @State private var selectedImage: UIImage? = UIImage(named: "1")
  @State private var selectedDate: Date = Date()

  @State private var daysUntilBirthday: Int = 0
  @State private var isShowingImagePicker = false
  @State private var isShowingDatePicker = false

  var body: some View {
    VStack {
      HStack {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
          Image(uiImage: selectedImage ?? UIImage(named: "1")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .onTapGesture {
              hideKeyboard()
            }

          Button {
            self.isShowingImagePicker.toggle()
          } label: {
            ZStack {
              Circle()
                .frame(width: 36, height: 36)
                .foregroundColor(.pink)
                .overlay(RoundedRectangle(cornerRadius: 18)
                  .stroke(Color.white, lineWidth: 2)
                )
              Image(systemName: "camera.fill")
                .foregroundColor(.white)
            }
            .offset(x: 4, y: 4)
            .fullScreenCover(isPresented: $isShowingImagePicker) {
              ImagePicker(image: $selectedImage)
            }
          }

        }

        VStack(alignment: .leading) {
          TextField("Name", text: $name)
            .font(.title)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onTapGesture {
              self.isShowingDatePicker = false
            }

          Divider()
            .padding(.horizontal)

          Text("Days Until Birthday: \(daysUntilBirthday)")
            .font(.headline)
            .padding(.horizontal)
            .onTapGesture {
              hideKeyboard()
            }
        }
      }
      .padding()

      Divider()
        .padding(.horizontal)

      HStack {
        Text(dateFormatter.string(from: selectedDate))
          .font(.title)

        Button(action: {
          isShowingDatePicker.toggle()
          hideKeyboard()
        }) {
          Image(systemName: "calendar")
            .resizable()
            .frame(width: 25, height: 25)
            .padding()
        }
        .accentColor(.blue)
      }
      .padding()


      if isShowingDatePicker {
        CustomDatePicker(selectedDate: $selectedDate, isShowing: $isShowingDatePicker)
          .transition(.slide)
      }


      Spacer()

      Button(action: {
        // Perform add friend action
        hideKeyboard()
        shouldUpdateFriends = true
        addFriend()
        presentationMode.wrappedValue.dismiss()
      }) {
        Text("Add Friend")
          .font(.title)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .padding()
    }
    .onChange(of: selectedDate, perform: { date in
      daysUntilBirthday = calculateDaysUntilBirthday(from: date)
    })
  }
}




private extension AddFriendView {

  func addFriend() {
    guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
      return
    }
    guard let age = calculateAge(from: selectedDate) else { return }
    let nextYear = Calendar.current.component(.year, from: Date()) + 1
    let id = UUID()
    print("В следующем году в \(nextYear) году вам будет \(age) год(а)")
    let friend = Friend(id: id, name: name, avatar: imageData, birthday: calculateBirthday(selectedDate), daysUntilBirthday: calculateDaysUntilBirthday(from: selectedDate), turns: age, date: selectedDate)
    DatabaseService.shared.saveFriend(friend)
  }

  func calculateAge(from selectedDate: Date) -> Int? {
    let currentDate = Date() // Текущая дата
    let calendar = Calendar.current

    let currentYear = calendar.component(.year, from: currentDate)
    let selectedYear = calendar.component(.year, from: selectedDate)

    let currentMonth = calendar.component(.month, from: currentDate)
    let selectedMonth = calendar.component(.month, from: selectedDate)

    let currentDay = calendar.component(.day, from: currentDate)
    let selectedDay = calendar.component(.day, from: selectedDate)

    var age = currentYear - selectedYear + 1 // Разница в годах

    // Проверяем, прошла ли уже выбранная дата в текущем году
    if selectedMonth > currentMonth || (selectedMonth == currentMonth && selectedDay > currentDay) {
      // Если выбранная дата еще не наступила в текущем году, вычитаем 1 год из возраста
      age -= 1
    }

    return age
  }

  func calculateBirthday(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d"
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
  }

  func calculateDaysUntilBirthday(from date: Date) -> Int {
    let currentDate = Date()
    let currentComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
    var selectedComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
    selectedComponents.year = currentComponents.year
    if let selectedDate = Calendar.current.date(from: selectedComponents) {
      if selectedDate < currentDate {
        selectedComponents.year? += 1
      }
      let nextBirthday = Calendar.current.date(from: selectedComponents)!
      let daysUntilNextBirthday = Calendar.current.dateComponents([.day], from: currentDate, to: nextBirthday).day!
      return daysUntilNextBirthday
    }
    return 0
  }

  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
