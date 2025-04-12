//
//  Day.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//


import SwiftUI
import Observation

struct Day: Identifiable, Codable {
    let id: Int
    let date: Date
    let title: String
    let description: String
    let facts: [Fact]
    let requiredEnergy: Int  // Energy required to unlock if past day
    var isCompleted: Bool = false

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}