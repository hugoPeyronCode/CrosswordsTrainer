//
//  LetterInputField.swift
//  CrosswordsTrainer
//
//  Created by Hugo Peyron on 11/04/2025.
//

import SwiftUI
import Observation

struct SimplifiedLetterInput: View {
  @Binding var answer: String
  let wordLength: Int
  var onSubmit: () -> Void

  @State private var isFocused = false
  @FocusState private var textFieldFocused: Bool

  var body: some View {
    HStack(spacing: 2) {
      ForEach(0..<wordLength, id: \.self) { index in
        letterBox(at: index)
      }
      Color.clear
        .frame(width: 0, height: 0)
        .overlay(
          TextField("", text: $answer)
            .textInputAutocapitalization(.characters)
            .disableAutocorrection(true)
            .focused($textFieldFocused)
            .frame(width: 1, height: 1)
            .opacity(0.01)
            .onSubmit { onSubmit() }  // Handle Enter key press
        )
    }
    .padding(4)
    .contentShape(Rectangle())
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(isFocused ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 2)
    )
    .onTapGesture {
      textFieldFocused = true
    }
    .onChange(of: answer) { _, newValue in
      if newValue.count > wordLength {
        answer = String(newValue.prefix(wordLength))
      }
    }
    .onChange(of: textFieldFocused) { _, newValue in
      withAnimation(.easeInOut(duration: 0.1)) {
        isFocused = newValue
      }
    }
  }

  // Extract each letter box into a separate function for clarity
  private func letterBox(at index: Int) -> some View {
    ZStack {
      Rectangle()
        .fill(index < answer.count ? Color(.systemGray5) : Color(.systemGray6))
        .frame(width: 24, height: 28)
        .cornerRadius(4)
        .overlay(
          RoundedRectangle(cornerRadius: 4)
            .stroke(isFocused ? Color.accentColor : Color(.systemGray3),
                    lineWidth: 1)
        )

      if index < answer.count {
        let stringIndex = answer.index(answer.startIndex, offsetBy: index)
        Text(String(answer[stringIndex]).uppercased())
          .font(.system(size: 14, weight: .bold))
          .foregroundColor(.primary)
      }
    }
  }
}

// MARK: - Interactive Previews

struct SimplifiedLetterInput_Previews: PreviewProvider {
  struct InteractivePreview: View {
    @State private var text1 = "HELLO"
    @State private var text2 = ""
    @State private var text3 = "SW"
    @State private var submitCount = 0
    @State private var lastSubmitted = ""

    var body: some View {
      ScrollView {
        VStack(spacing: 24) {
          Text("SimplifiedLetterInput Demo")
            .font(.headline)
            .padding(.top)

          // Example 1: Pre-filled input
          VStack(alignment: .leading, spacing: 8) {
            Text("Pre-filled (5 letters)")
              .font(.subheadline)
              .foregroundColor(.secondary)

            SimplifiedLetterInput(
              answer: $text1,
              wordLength: 5,
              onSubmit: {
                submitCount += 1
                lastSubmitted = text1
              }
            )

            Text("Current value: \"\(text1)\"")
              .font(.caption)
              .padding(.top, 4)
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(8)

          // Example 2: Empty input
          VStack(alignment: .leading, spacing: 8) {
            Text("Empty input (8 letters)")
              .font(.subheadline)
              .foregroundColor(.secondary)

            SimplifiedLetterInput(
              answer: $text2,
              wordLength: 8,
              onSubmit: {
                submitCount += 1
                lastSubmitted = text2
              }
            )

            Text("Current value: \"\(text2)\"")
              .font(.caption)
              .padding(.top, 4)
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(8)

          // Example 3: Partially filled
          VStack(alignment: .leading, spacing: 8) {
            Text("Partially filled (4 letters)")
              .font(.subheadline)
              .foregroundColor(.secondary)

            SimplifiedLetterInput(
              answer: $text3,
              wordLength: 4,
              onSubmit: {
                submitCount += 1
                lastSubmitted = text3
              }
            )

            Text("Current value: \"\(text3)\"")
              .font(.caption)
              .padding(.top, 4)
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(8)

          // Submit tracker
          VStack(spacing: 8) {
            Text("Enter key pressed: \(submitCount) times")
              .font(.caption)
              .foregroundColor(.secondary)

            if !lastSubmitted.isEmpty {
              Text("Last submitted: \"\(lastSubmitted)\"")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(8)

          // Clear all button
          Button("Clear All Inputs") {
            text1 = ""
            text2 = ""
            text3 = ""
          }
          .padding()
          .background(Color.accentColor)
          .foregroundColor(.white)
          .cornerRadius(8)
        }
        .padding()
      }
      .background(Color(.systemGroupedBackground))
    }
  }

  // Single example preview
  struct SimplePreview: View {
    @State private var inputText = "WORD"

    var body: some View {
      VStack(spacing: 10) {
        SimplifiedLetterInput(
          answer: $inputText,
          wordLength: 6,
          onSubmit: { print("Submitted: \(inputText)") }
        )

        Text("Type here: \(inputText)")
          .padding(.top)
      }
      .padding()
      .previewLayout(.sizeThatFits)
    }
  }

  static var previews: some View {
    Group {
      InteractivePreview()
        .previewDisplayName("Interactive Demo")

      SimplePreview()
        .previewDisplayName("Simple Example")
        .previewLayout(.sizeThatFits)
    }
  }
}
