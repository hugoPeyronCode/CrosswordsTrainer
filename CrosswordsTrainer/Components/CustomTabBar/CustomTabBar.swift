//
//  CustomTabBar.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//

import SwiftUI

struct CustomTabBar: View {
  @Binding var selectedTab: ViewMode

  enum ViewMode {
    case facts, clues, wordGame
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 30)
        .foregroundStyle(.thinMaterial)
        .shadow(color: Color.primary.opacity(0.1), radius: 8, x: 0, y: 4)

      HStack {
        TabButton(
          icon: "book.fill",
          isSelected: selectedTab == .facts,
          action: { withAnimation { selectedTab = .facts } }
        )

        Spacer()

        TabButton(
          icon: "questionmark.circle.fill",
          isSelected: selectedTab == .clues,
          action: { withAnimation { selectedTab = .clues } }
        )

        Spacer()

        TabButton(
          icon: "gamecontroller.fill",
          isSelected: selectedTab == .wordGame,
          action: { withAnimation { selectedTab = .wordGame } }
        )
      }
      .padding(.horizontal, 30)
    }
    .containerRelativeFrame(.vertical) { height, _ in height / 12 }
    .containerRelativeFrame(.horizontal) { width, _ in width / 1.5 }
  }
}

struct TabButton: View {
  let icon: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Image(systemName: icon)
          .font(.title2)
          .foregroundColor(isSelected ? .accentColor : .gray)

        Circle()
          .fill(isSelected ? Color.accentColor : Color.clear)
          .frame(width: 5, height: 5)
      }
      .frame(width: 45, height: 45)
      .contentShape(Rectangle())
    }
  }
}


#Preview {
  CustomTabBar(selectedTab: .constant(.wordGame))
}
