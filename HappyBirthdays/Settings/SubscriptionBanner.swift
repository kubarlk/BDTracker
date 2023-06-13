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
      LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
          .cornerRadius(16)
          .scaleEffect(bannerAnimation ? 1.0 : 0.5)


          .opacity(bannerAnimation ? 1 : 0)

      HStack {
        Image("1")
            .resizable()
            .frame(width: 56, height: 56)
            .foregroundColor(.white)
            .cornerRadius(8)
            .opacity(imageAnimation ? 1 : 0)
            .scaleEffect(imageAnimation ? 1 : 0.5)
            .animation(.spring(), value: imageAnimation)


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
    .onTapGesture {
        withAnimation {
            showSubscriptionSheet.toggle()
        }
    }
    .frame(height: 56)
    .padding(16)
    .sheet(isPresented: $showSubscriptionSheet) {
      SubscriptionView()
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
