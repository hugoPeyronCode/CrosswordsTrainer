//
//  AnswerStatus.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

enum AnswerStatus: Equatable {
  case unanswered
  case correct
  case revealed
  case close(String)

  var isAnswered: Bool {
    if case .correct = self { return true }
    return false
  }

  var isRevealed: Bool {
    if case .revealed = self { return true }
    return false
  }

  var isClose: Bool {
    if case .close = self { return true }
    return false
  }

  var closeAttempt: String? {
    if case .close(let attempt) = self { return attempt }
    return nil
  }
}