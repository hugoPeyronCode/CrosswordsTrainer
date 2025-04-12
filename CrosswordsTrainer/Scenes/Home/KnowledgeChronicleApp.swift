//
//  KnowledgeChronicleApp.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//

import SwiftUI
import Observation

struct KnowledgeChronicleApp: View {
  @State private var viewModel = KnowledgeViewModel()

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
          Group {
            if viewModel.viewMode == .train {
              VerticalScrollingFactsView(viewModel: viewModel)
                .transition(.opacity)
            } else {

              SagaMapView()
                .transition(.opacity)

//              WordGameView(viewModel: viewModel)
//                .transition(.opacity)
            }
          }
          .padding()

        Picker("View Mode", selection: $viewModel.viewMode) {
          Text("Today").tag(KnowledgeViewModel.ViewMode.wordGame)
          Text("Train").tag(KnowledgeViewModel.ViewMode.train)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
      }
    }
  }
}

#Preview {
  KnowledgeChronicleApp()
}
