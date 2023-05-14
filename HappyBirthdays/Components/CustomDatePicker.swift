//
//  CustomDatePicker.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 14.05.23.
//

import SwiftUI


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
