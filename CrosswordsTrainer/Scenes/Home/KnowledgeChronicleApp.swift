//
//  KnowledgeChronicleApp.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//

import SwiftUI
import Observation

struct KnowledgeChronicleApp: View {
  @State var appState: AppStateManager

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Group {
          switch appState.viewMode {
          case .train:
            VerticalScrollingFactsView(appState: appState)
              .transition(.opacity)
          case .saga:
            SagaMapView(appState: appState)
              .transition(.opacity)
          }
        }
        .padding()

        // Tab bar
        Picker("View Mode", selection: $appState.viewMode) {
          Text("Map").tag(AppStateManager.ViewMode.saga)
          Text("Train").tag(AppStateManager.ViewMode.train)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: appState.viewMode) { oldValue, newValue in
          // Only call switchToTrainingMode when going from a different mode to train
          if newValue == .train && oldValue != .train {
            appState.switchToTrainingMode()
          }
        }
      }
    }
    .onAppear {
      // Initialize progression tracking when the app appears
      appState.progressViewModel.checkAndResetDailyProgress()
    }
  }
}

#Preview {
  KnowledgeChronicleApp(appState: AppStateManager())
}
