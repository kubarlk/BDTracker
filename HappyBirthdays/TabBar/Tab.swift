//
//  Tab.swift
//  HappyBirthdays
//
//  Created by Kirill Kubarskiy on 19.05.23.
//

import SwiftUI

enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case contacts, wishes, settings

    internal var id: Int { rawValue }

    var icon: String {
        switch self {
        case .contacts:
            return "person.3"
        case .wishes:
            return "birthday.cake"
        case .settings:
            return "gear"

        }
    }
}


