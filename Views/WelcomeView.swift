//
//  WelcomeView.swift
//  BubblePopPop
//
//  Created by 牙后慧 on 2025/4/21.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var gameSettings: GameSettings
    @State private var tempPlayerName: String = ""
    var onNameSubmitted: () -> Void
    
    // Maximum character limit for username
    private let maxNameLength = 20
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to BubblePopPop")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Enter your name:")
                    .font(.headline)
                
                TextField("Your Name", text: $tempPlayerName)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .autocorrectionDisabled()
                    .padding(.horizontal)
                    .onChange(of: tempPlayerName) { oldValue, newValue in
                        // Limit to 20 characters
                        if newValue.count > maxNameLength {
                            tempPlayerName = String(newValue.prefix(maxNameLength))
                        }
                    }
                
                Text("\(tempPlayerName.count)/\(maxNameLength)")
                    .font(.caption)
                    .foregroundColor(tempPlayerName.count >= maxNameLength ? .red : .gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                let trimmedName = tempPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedName.isEmpty {
                    gameSettings.playerName = trimmedName
                    onNameSubmitted()
                }
            }) {
                Text("Start Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .disabled(tempPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(red: 0.9, green: 0.9, blue: 0.95))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Pre-fill with previous name if available
            if !gameSettings.playerName.isEmpty {
                tempPlayerName = gameSettings.playerName
            }
        }
    }
}

// Custom text field style with a border
struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    .background(Color.white.cornerRadius(8))
            )
    }
}
