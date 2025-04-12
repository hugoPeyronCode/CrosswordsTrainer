//
//  WordGameView 2.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

struct WordGameView: View {
  var appState: AppStateManager

  // Access the game view model through the app state
  private var viewModel: GameViewModel {
    appState.gameViewModel
  }
  
  var body: some View {
    VStack(spacing: 12) {
      // Header controls
      VStack(spacing: 8) {
        HStack {
          Text(formattedDate)
            .font(.title3)
            .fontWeight(.bold)
          
          Spacer()
          
          Button(action: {
            appState.returnToMap()
          }) {
            Text("Back to Map")
              .font(.subheadline)
              .foregroundColor(.blue)
          }
        }
        
        // Progress section
        VStack(spacing: 4) {
          HStack {
            Text("Batch #\(viewModel.questionBatch)")
              .font(.caption)
              .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(viewModel.completedCount) of \(viewModel.facts.count) solved")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          
          ProgressView(value: viewModel.progressPercentage, total: 100)
            .animation(.bouncy, value: viewModel.progressPercentage)
            .progressViewStyle(LinearProgressViewStyle())
        }
      }
      .padding(.horizontal)
      
      
      // Clues grid
      ScrollView {
        ForEach(viewModel.facts) { fact in
          FactClueCell(fact: fact, appState: appState)
        }
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
  }
  
  // Format today's date
  private var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: Date())
  }
}

#Preview {
  WordGameView(appState: AppStateManager())
}