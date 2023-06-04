//
//  SubscriptionBanner.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 4.06.23.
//

import SwiftUI

struct SubscriptionBanner: View {
  @State private var bannerAnimation = false
  @State private var imageAnimation = false
  @State private var showSubscriptionSheet = false

  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .leading, endPoint: .trailing)
        .cornerRadius(16)
        .scaleEffect(bannerAnimation ? 1.0 : 0.5)
        .animation(.spring())
        .onTapGesture {
          showSubscriptionSheet.toggle()
        }
        .opacity(bannerAnimation ? 1 : 0)

      HStack {
        Image("1")
          .resizable()
          .frame(width: 56, height: 56)
          .foregroundColor(.white)
          .cornerRadius(8)
          .opacity(imageAnimation ? 1 : 0)
          .scaleEffect(imageAnimation ? 1 : 0.5)
          .animation(.spring())

        VStack(alignment: .leading) {
          Text("Получить премиум")
            .font(.headline)
            .foregroundColor(.white)

          Text("Просмотреть преимущества премиума")
            .font(.subheadline)
            .foregroundColor(.white)
        }
        .padding(.leading, 8)

        Spacer()
      }
      .padding(8)
    }
    .frame(height: 56)
    .padding(16)
    .sheet(isPresented: $showSubscriptionSheet) {
      // Окно подписок
      Text("Окно подписок")
    }
    .onAppear {
        withAnimation(.spring()) {
          bannerAnimation.toggle()

      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        withAnimation(.spring()) {
          imageAnimation.toggle()
        }
      }
    }
  }
}
struct SubscriptionBanner_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionBanner()
    }
}