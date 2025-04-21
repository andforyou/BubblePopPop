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
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to BubblePopPop")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Input your name please:")
                    .font(.headline)
                
                TextField("Your Name", text: $tempPlayerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .padding(.horizontal)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                if !tempPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    gameSettings.playerName = tempPlayerName
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
    }
}
