//
//  SubscriptionView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 4.06.23.
//

import SwiftUI

struct SubscriptionView: View {
    @State private var isSubscribing = false
    @State private var selectedPlan: SubscriptionPlan?

    let subscriptionPlans = [
        SubscriptionPlan(name: "Ежемесячная подписка", price: 9.99),
        SubscriptionPlan(name: "Годовая подписка", price: 99.99)
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Подписки")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.top, 30)

            Image(systemName: "newspaper")
                .font(.system(size: 100))
                .foregroundColor(.green)
                .scaleEffect(isSubscribing ? 1.2 : 1.0)
                .animation(.spring())

            Text("Получите доступ к эксклюзивному контенту и преимуществам подписки.")
                .multilineTextAlignment(.center)
                .foregroundColor(.green)

            ForEach(subscriptionPlans) { plan in
                SubscriptionPlanView(plan: plan, isSelected: plan == selectedPlan) {
                    selectedPlan = plan
                }
                .animation(.spring())
            }

            Button(action: {
                isSubscribing.toggle()
            }) {
                Text("Оформить подписку")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            if let selectedPlan = selectedPlan {
                let savings = selectedPlan.yearlySavings
                Text("Экономьте \(savings, specifier: "%.2f")$ ежегодно!")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
        


    }
}

struct SubscriptionPlanView: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(plan.name)
                .font(.headline)
                .foregroundColor(.green)

            Text("$\(plan.price, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)

            if isSelected {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
                    .padding(.bottom, 8)
            }
        }
        .padding()
        .background(isSelected ? Color.green.opacity(0.2) : Color.white)
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
    }
}

struct SubscriptionPlan: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let price: Double

    var yearlySavings: Double {
        let yearlyPrice = price * 12
        let discountedPrice = price * 10
        return yearlyPrice - discountedPrice
    }
}



struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
