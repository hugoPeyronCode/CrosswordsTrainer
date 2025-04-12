//
//  FactClueCell.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

struct FactClueCell: View {
  let fact: Fact
  var appState: AppStateManager
  @State private var userInput = ""
  
  // Access the game view model through the app state
  private var viewModel: GameViewModel {
    appState.gameViewModel
  }
  
  var answerStatus: AnswerStatus {
    return viewModel.answerStatuses[fact.id] ?? .unanswered
  }
  
  var category: Category {
    return Category.getCategory(by: fact.category)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Image(systemName: category.iconName)
          .font(.system(size: 10))
          .foregroundColor(.secondary)
        
        Text(fact.category)
          .font(.caption)
          .foregroundColor(.secondary)
        
        Spacer()
        
        if answerStatus.isAnswered {
          Text("SOLVED")
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.green)
        } else if answerStatus.isRevealed {
          Text("REVEALED")
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.blue)
        } else if answerStatus.isClose {
          Text("CLOSE")
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.orange)
        }
      }
      .padding(.bottom, 2)
      .overlay(
        Rectangle()
          .frame(height: 1)
          .foregroundColor(Color(.systemGray5))
          .offset(y: 1),
        alignment: .bottom
      )
      
      // Clue
      Text(fact.clue)
        .font(.footnote)
        .fontWeight(.medium)
        .foregroundColor(clueTextColor)
        .fixedSize(horizontal: false, vertical: true)
      
      // Answer section
      VStack(alignment: .leading, spacing: 4) {
        if answerStatus.isAnswered {
          Text(fact.formattedAnswer)
            .font(.footnote)
            .fontWeight(.bold)
            .foregroundColor(.green)
        } else if answerStatus.isRevealed {
          Text(fact.formattedAnswer)
            .font(.footnote)
            .fontWeight(.bold)
            .foregroundColor(.blue)
        } else if answerStatus.isClose {
          if let attempt = answerStatus.closeAttempt {
            Text("You wrote: \"\(attempt)\"")
              .font(.caption)
              .foregroundColor(.orange)
            Text("It was: \"\(fact.formattedAnswer)\"")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        } else {
          // Letter input boxes
          VStack(alignment: .leading, spacing: 4) {
            VStack(spacing: 4) {
              
              SimplifiedLetterInput(
                answer: $userInput,
                wordLength: fact.answer.count,
                onSubmit: {
                  viewModel.checkAnswer(for: fact.id, userAnswer: userInput)
                }
              )
              .padding(10)
              
              HStack {
                Spacer()
                Button("Reveal") {
                  withAnimation {
                    viewModel.revealAnswer(for: fact.id)
                  }
                }
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .cornerRadius(4)
              }
            }
          }
        }
      }
      
      // Fact explanation when answered
      if (answerStatus.isAnswered || answerStatus.isRevealed || answerStatus.isClose) {
        Text(fact.fact)
          .font(.caption)
          .italic()
          .foregroundColor(factTextColor)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .padding()
    .background(cellBackgroundColor)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(cellBorderColor, lineWidth: 1)
    )
  }
  
  // Dynamic colors based on answer status
  private var cellBackgroundColor: Color {
    switch answerStatus {
    case .correct:
      return Color.green.opacity(0.1)
    case .revealed:
      return Color.blue.opacity(0.1)
    case .close:
      return Color.orange.opacity(0.1)
    case .unanswered:
      return Color(.systemBackground)
    }
  }
  
  private var cellBorderColor: Color {
    switch answerStatus {
    case .correct:
      return Color.green.opacity(0.3)
    case .revealed:
      return Color.blue.opacity(0.3)
    case .close:
      return Color.orange.opacity(0.3)
    case .unanswered:
      return Color(.systemGray4)
    }
  }
  
  private var clueTextColor: Color {
    switch answerStatus {
    case .correct:
      return Color.green
    case .revealed:
      return Color.blue
    case .close:
      return Color.orange
    case .unanswered:
      return Color.primary
    }
  }
  
  private var factTextColor: Color {
    switch answerStatus {
    case .correct:
      return Color.green
    case .revealed:
      return Color.blue
    case .close:
      return Color.orange
    case .unanswered:
      return Color.secondary
    }
  }
}

#Preview {
  FactClueCell(
    fact: Fact(id: 10, clue: "Super clue", answer: "test answer", fact: "Sample fact explanation", category: "History"), 
    appState: AppStateManager()
  )
}