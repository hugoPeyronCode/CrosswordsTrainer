//
//  VerticalScrollingFactsView.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

struct VerticalScrollingFactsView: View {
  @State var appState: AppStateManager
  
  var body: some View {
    GeometryReader { screen in
      TabView(selection: $appState.gameViewModel.currentFactIndex) {
        ForEach(Array(appState.gameViewModel.facts.enumerated()), id: \.element.id) { index, fact in
          FactClueCell(fact: appState.gameViewModel.facts[index], appState: appState)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
            .frame(width: screen.size.width, height: screen.size.height * 0.85)
            .rotationEffect(Angle(degrees: -90))
            .tag(index)
        }
      }
      .frame(width: screen.size.height, height: screen.size.width)
      .rotationEffect(.degrees(90), anchor: .topLeading)
      .offset(x: screen.size.width)
      .tabViewStyle(.page(indexDisplayMode: .never))
      .onChange(of: appState.gameViewModel.currentFactIndex) { oldValue, newValue in
        appState.gameViewModel.showAnswer = false
      }
    }
  }
}

#Preview {
  VerticalScrollingFactsView(appState: AppStateManager())
}
