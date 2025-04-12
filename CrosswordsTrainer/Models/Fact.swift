//
//  Fact.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//


import SwiftUI
import Observation

/// Fact model containing clues, answers, and facts
struct Fact: Identifiable, Codable {
  let id: Int
  let clue: String
  let answer: String
  let fact: String
  let category: String

  var formattedAnswer: String {
    return answer.uppercased()
  }
}

// MARK: - Models

// Extension to define sample facts
extension Fact {
  static let initialFacts: [Fact] = [
    Fact(id: 1, clue: "Asian nation with a 13,000+ mile 'Great' barrier", answer: "CHINA", fact: "The Great Wall of China stretches over 13,000 miles and is visible from space in certain conditions.", category: "Geography"),
    Fact(id: 2, clue: "Cardiovascular pump first transplanted in 1967", answer: "HEART", fact: "Dr. Christiaan Barnard performed the first successful human heart transplant in Cape Town, South Africa.", category: "Science"),
    Fact(id: 3, clue: "Sweet baked dessert allegedly suggested by Marie Antoinette", answer: "CAKE", fact: "Marie Antoinette never actually said 'Let them eat cake' - it was a phrase attributed to an unnamed 'great princess'.", category: "History"),
    Fact(id: 4, clue: "Longest side of a right triangle", answer: "HYPOTENUSE", fact: "The Pythagorean theorem states that the square of the hypotenuse equals the sum of squares of the other two sides.", category: "Mathematics"),
    Fact(id: 5, clue: "Body part Vincent van Gogh infamously sliced", answer: "EAR", fact: "Van Gogh cut off part of his left ear in 1888 during a psychotic episode and presented it to a prostitute.", category: "Arts"),
    Fact(id: 6, clue: "Exceptionally gifted youngster, like the 5-year-old composer Wolfgang", answer: "PRODIGY", fact: "Mozart was playing instruments at 3, composing at 5, and wrote his first symphony at just 8 years old.", category: "Music"),
    Fact(id: 7, clue: "Big Apple borough that hosts the UN headquarters", answer: "MANHATTAN", fact: "The United Nations headquarters has been located in Manhattan since 1952 and sits on international territory.", category: "Society"),
    Fact(id: 8, clue: "Only metal that's liquid at room temperature", answer: "MERCURY", fact: "Mercury is toxic to humans and was once used in thermometers before being phased out for safety reasons.", category: "Science"),
    Fact(id: 9, clue: "Drink dumped in Boston Harbor during a famous 1773 'party'", answer: "TEA", fact: "The Boston Tea Party protesters dumped 342 chests of tea, worth about $1.7 million in today's dollars.", category: "History"),
    Fact(id: 10, clue: "Elizabethan venue where Shakespeare's works premiered", answer: "GLOBE", fact: "The original Globe Theatre burned down in 1613 when a cannon shot during a performance set fire to the thatched roof.", category: "Arts")
  ]

  static let additionalFacts: [Fact] = [
    Fact(id: 21, clue: "Yellowstone's most famous geyser, erupting on schedule", answer: "OLDFAITHFUL", fact: "Old Faithful erupts approximately every 90 minutes, shooting water up to 185 feet into the air.", category: "Geography"),
    Fact(id: 22, clue: "Particle with positive charge in an atom's nucleus", answer: "PROTON", fact: "The number of protons in an atom's nucleus determines which element it is on the periodic table.", category: "Science"),
    Fact(id: 23, clue: "Ancient Egyptian ruler entombed with golden treasures", answer: "TUTANKHAMUN", fact: "King Tut's tomb was discovered in 1922 by Howard Carter and contained over 5,000 artifacts.", category: "History"),
    Fact(id: 24, clue: "Value of π (pi) rounded to first decimal place", answer: "THREE", fact: "While commonly approximated as 3.14, pi is an irrational number that continues infinitely without repeating.", category: "Mathematics"),
    Fact(id: 25, clue: "Italian Renaissance painter of 'The Birth of Venus'", answer: "BOTTICELLI", fact: "Botticelli later became influenced by religious zealot Savonarola and may have destroyed some of his own paintings.", category: "Arts")
  ]
}
