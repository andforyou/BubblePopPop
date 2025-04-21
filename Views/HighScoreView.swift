//
//  HighScoreView.swift
//  BubblePopPop
//
//  Created on 2025/4/21.
//

import SwiftUI

struct HighScoreView: View {
    @ObservedObject var scoreManager: ScoreManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .shadow(radius: 2)
                
                Text("Score Board")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(height: 60)
            
            // Score list
            if scoreManager.highScores.isEmpty {
                Spacer()
                Text("No scores yet!")
                    .font(.title2)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(scoreManager.highScores) { playerScore in
                        HStack {
                            Text(playerScore.playerName)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(playerScore.score)")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            
            // Restart button
            Button(action: {
                dismiss()
            }) {
                Text("Play Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
