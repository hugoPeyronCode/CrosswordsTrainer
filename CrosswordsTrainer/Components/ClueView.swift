//
//  ClueView.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

struct ClueView: View {
  @Bindable var viewModel: KnowledgeViewModel

  var body: some View {
    VStack {
      // Main card
      VStack(alignment: .leading, spacing: 12) {
        // Category header
        HStack {
          CategoryIcon(category: Category.getCategory(by: viewModel.currentFact.category))

          Text(viewModel.currentFact.category)
            .font(.subheadline)
            .foregroundColor(.secondary)

          Spacer()
        }
        .padding(.bottom, 8)
        .overlay(
          Rectangle()
            .frame(height: 1)
            .foregroundColor(Color(.systemGray5))
            .offset(y: 4),
          alignment: .bottom
        )

        // Clue content
        VStack(alignment: .leading, spacing: 8) {
          Text("CLUE:")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.secondary)

          Text(viewModel.currentFact.clue)
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
        }

        // Show answer button
        Button(action: { viewModel.showAnswer.toggle() }) {
          Text(viewModel.showAnswer ? "Hide Answer" : "Show Answer")
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }

        // Answer section
        if viewModel.showAnswer {
          VStack(alignment: .leading, spacing: 8) {
            Text("Answer: \(viewModel.currentFact.answer)")
              .fontWeight(.bold)
              .foregroundColor(.primary)

            Text("Related fact: \(viewModel.currentFact.fact)")
              .font(.subheadline)
              .foregroundColor(.secondary)
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding()
          .background(Color(.systemGray6))
          .cornerRadius(8)
        }
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
      .padding(.horizontal)
    }
  }
}