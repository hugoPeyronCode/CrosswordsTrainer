//
//  Category.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//

import SwiftUI
import Observation

/// Category model for different knowledge domains
struct Category: Identifiable {
  let id = UUID()
  let name: String
  let color: Color
  let iconName: String

  static let all: [Category] = [
    Category(name: "History", color: .brown, iconName: "book.fill"),
    Category(name: "Geography", color: .blue, iconName: "globe"),
    Category(name: "Science", color: .green, iconName: "flask.fill"),
    Category(name: "Arts", color: .orange, iconName: "paintpalette.fill"),
    Category(name: "Music", color: .purple, iconName: "music.note"),
    Category(name: "Mathematics", color: .cyan, iconName: "function"),
    Category(name: "Society", color: .pink, iconName: "person.2.fill")
  ]

  static func getCategory(by name: String) -> Category {
    return all.first { $0.name == name } ?? all[0]
  }
}
