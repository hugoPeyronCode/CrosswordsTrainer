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
    var onSubmit: () -> Void  // New callback for Enter key

    @State private var isFocused = false
    @FocusState private var textFieldFocused: Bool

    var body: some View {
        // Simplified layout with fewer nested views
        HStack(spacing: 2) {
            // Letter boxes shown side by side
            ForEach(0..<wordLength, id: \.self) { index in
                letterBox(at: index)
            }

            // The invisible text field positioned in a way that won't affect layout
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
