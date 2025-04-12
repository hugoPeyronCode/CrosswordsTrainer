//
//  GameViewModel.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//

import SwiftUI
import Observation

/// ViewModel focused solely on gameplay mechanics
@Observable
class GameViewModel {
    // Game state
    var facts: [Fact] = []
    var answerStatuses: [Int: AnswerStatus] = [:]
    var currentFactIndex: Int = 0
    var showAnswer: Bool = false
    var questionBatch: Int = 1
    var progressPercentage: Double = 0
    
    // Completion callback
    var onGameCompletion: (() -> Void)?
    
    // MARK: - Setup
    
    /// Initialize game with specific facts
    func setupGameWithFacts(_ newFacts: [Fact]) {
        facts = newFacts
        restart()
    }
    
    // MARK: - Computed Properties
    
    var currentFact: Fact {
        guard !facts.isEmpty, currentFactIndex < facts.count else {
            // Return a dummy fact if none available
            return Fact(id: 0, clue: "No facts available", answer: "", fact: "", category: "")
        }
        return facts[currentFactIndex]
    }
    
    var completedCount: Int {
        return answerStatuses.values.filter {
            if case .correct = $0 { return true }
            return false
        }.count
    }
    
    var isGameCompleted: Bool {
        // Consider it completed if 80% or more facts are answered correctly
        return completedCount >= Int(Double(facts.count) * 0.8)
    }
    
    // MARK: - Game Logic
    
    func checkAnswer(for factId: Int, userAnswer: String) {
        guard !userAnswer.isEmpty else { return }
        
        let fact = facts.first { $0.id == factId }!
        let correctAnswer = fact.answer.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedUserAnswer = userAnswer.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedUserAnswer == correctAnswer {
            answerStatuses[factId] = .correct
            updateProgress()
        } else {
            // Check if answer is close using Levenshtein distance
            let distance = levenshteinDistance(correctAnswer, cleanedUserAnswer)
            let isLengthReasonable = cleanedUserAnswer.count >= correctAnswer.count * Int(0.75) &&
            cleanedUserAnswer.count <= correctAnswer.count + 2
            let maxAllowedDistance = correctAnswer.count > 8 ? 3 : 2
            
            if isLengthReasonable && distance <= maxAllowedDistance {
                answerStatuses[factId] = .close(cleanedUserAnswer)
            }
        }
        
        checkCompletion()
    }
    
    func revealAnswer(for factId: Int) {
        answerStatuses[factId] = .revealed
    }
    
    private func updateProgress() {
        progressPercentage = Double(completedCount) / Double(facts.count) * 100.0
    }
    
    // MARK: - Game Management
    
    func restart() {
        answerStatuses = [:]
        progressPercentage = 0
        currentFactIndex = 0
        showAnswer = false
    }
    
    // Check if game is completed and trigger callback
    private func checkCompletion() {
        updateProgress()
        if isGameCompleted {
            onGameCompletion?()
        }
    }
    
    // MARK: - Helper Functions
    
    // Levenshtein distance calculation for close answer detection
    private func levenshteinDistance(_ a: String, _ b: String) -> Int {
        let a = Array(a)
        let b = Array(b)
        
        var matrix = Array(repeating: Array(repeating: 0, count: b.count + 1), count: a.count + 1)
        
        for i in 0...a.count {
            matrix[i][0] = i
        }
        
        for j in 0...b.count {
            matrix[0][j] = j
        }
        
        for i in 1...a.count {
            for j in 1...b.count {
                let cost = a[i-1] == b[j-1] ? 0 : 1
                matrix[i][j] = min(
                    matrix[i-1][j] + 1,     // deletion
                    matrix[i][j-1] + 1,     // insertion
                    matrix[i-1][j-1] + cost // substitution
                )
            }
        }
        
        return matrix[a.count][b.count]
    }
}