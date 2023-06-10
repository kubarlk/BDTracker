//
//  TimeLineView.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 9.06.23.
//

import SwiftUI

struct TimeLineView: View {
    var month: String

    var body: some View {
                VStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 32)
                        .overlay(
                            Text(month)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(4)
                    Circle()
                    .fill(Color.black.opacity(0.1))
                        .frame(width: 16)
                        .overlay(
                          Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                          )
                }
    }
}





struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
      TimeLineView(month: "sasa")
    }
}
