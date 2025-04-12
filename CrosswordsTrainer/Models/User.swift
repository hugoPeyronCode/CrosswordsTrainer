//
//  User.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 12/04/2025.
//


import SwiftUI
import Observation

struct User: Codable {
    var id: String = UUID().uuidString
    var energy: Int = 100
    var completedDays: [Int] = []
    var lastPlayedDate: Date?
}