//
//  ContentView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 2.05.23.
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
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
            return
        }
        guard let age = calculateAge(from: selectedDate) else { return }
        let nextYear = Calendar.current.component(.year, from: Date()) + 1
            print("В следующем году в \(nextYear) году вам будет \(age) год(а)")
        let friend = Friend(name: name, avatar: imageData, birthday: calculateBirthday(selectedDate), daysUntilBirthday: calculateDaysUntilBirthday(from: selectedDate), turns: age, date: selectedDate)
        DatabaseService.shared.saveFriend(friend)
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


struct CustomDatePicker: View {
  @Binding var selectedDate: Date
  @Binding var isShowing: Bool

  let maximumDate = Date() // Текущая дата

  var body: some View {
    VStack {
      DatePicker("", selection: $selectedDate, in: ...maximumDate, displayedComponents: .date) // Ограничение диапазона дат
        .datePickerStyle(GraphicalDatePickerStyle())
        .frame(height: 300)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 4, x: 0, y: 2)
    }
    .padding(.horizontal)
  }
}


let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd.MM.yyyy"
  return formatter
}()


struct Friend: Identifiable {
  let id = UUID()
  let name: String
  let avatar: Data
  let birthday: String
  let daysUntilBirthday: Int
  let turns: Int
  let date: Date
}





struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FriendsView()
  }
}



struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = context.coordinator
    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker

    init(parent: ImagePicker) {
      self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      if let selectedImage = info[.editedImage] as? UIImage {
        parent.image = selectedImage
      }
      picker.dismiss(animated: true)
    }
  }
}
