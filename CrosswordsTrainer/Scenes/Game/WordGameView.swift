//
//  WordGameView 2.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

struct WordGameView: View {
  @Bindable var viewModel: KnowledgeViewModel

  var body: some View {
    VStack(spacing: 12) {
      // Header controls
      VStack(spacing: 8) {
        HStack {
          Text("11 April 2025")
            .font(.title3)
            .fontWeight(.bold)

          Spacer()
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
          FactClueCell(fact: fact, viewModel: viewModel)
        }
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
  }
}

#Preview {
  WordGameView(viewModel: KnowledgeViewModel())
}
