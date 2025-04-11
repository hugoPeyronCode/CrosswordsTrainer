//
//  CategoryIcon.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

struct CategoryIcon: View {
  let category: Category

  var body: some View {
    Image(systemName: category.iconName)
      .foregroundColor(.white)
      .padding(6)
      .background(category.color)
      .cornerRadius(6)
  }
}