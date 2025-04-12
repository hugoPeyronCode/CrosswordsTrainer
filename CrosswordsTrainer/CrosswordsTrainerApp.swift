//
//  CrosswordsTrainerApp.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//

import SwiftUI

@main
struct CrosswordsTrainerApp: App {
  @State private var appState = AppStateManager()
  
  var body: some Scene {
    WindowGroup {
      KnowledgeChronicleApp(appState: appState)
    }
  }
}

#Preview {
  KnowledgeChronicleApp(appState: AppStateManager())
}
