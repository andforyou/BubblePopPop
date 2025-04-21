//
//  ScoreManager.swift
//  BubblePopPop
//
//  Created on 2025/4/21.
//

import Foundation

// Model for high scores
struct PlayerScore: Identifiable, Codable, Comparable {
    var id = UUID()
    let playerName: String
    let score: Int
    let date: Date
    
    static func < (lhs: PlayerScore, rhs: PlayerScore) -> Bool {
        return lhs.score > rhs.score // Sort in descending order
    }
}

class ScoreManager: ObservableObject {
    // Current game state
    @Published var currentScore: Int = 0
    @Published var lastPoppedBubbleColor: BubbleColor?
    @Published var consecutiveBubbles: Int = 0
    
    // High scores storage
    @Published var highScores: [PlayerScore] = []
    
    private let scoresKey = "highScores"
    
    init() {
        loadHighScores()
    }
    
    // Calculate points for a popped bubble
    func bubblePopped(color: BubbleColor) -> Int {
        let basePoints = color.points
        var pointsEarned = basePoints
        
        // Check if consecutive bubble of same color
        if let lastColor = lastPoppedBubbleColor, lastColor == color {
            consecutiveBubbles += 1
            // Apply 1.5x multiplier for consecutive bubbles after the first one
            if consecutiveBubbles > 1 {
                pointsEarned = Int(Double(basePoints) * 1.5)
            }
        } else {
            // Reset consecutive count for new color
            consecutiveBubbles = 1
        }
        
        // Save last popped color for next comparison
        lastPoppedBubbleColor = color
        
        // Update total score
        currentScore += pointsEarned
        return pointsEarned
    }
    
    // Reset score for new game
    func resetScore() {
        currentScore = 0
        lastPoppedBubbleColor = nil
        consecutiveBubbles = 0
    }
    
    // Save score at end of game
    func saveScore(playerName: String) {
        // Only save if score > 0
        if currentScore > 0 {
            let newScore = PlayerScore(
                playerName: playerName,
                score: currentScore,
                date: Date()
            )
            
            // Add to high scores
            highScores.append(newScore)
            
            // Sort and keep top 10
            highScores.sort()
            if highScores.count > 10 {
                highScores = Array(highScores.prefix(10))
            }
            
            // Save to disk
            saveHighScores()
        }
    }
    
    // Load high scores from UserDefaults
    private func loadHighScores() {
        if let data = UserDefaults.standard.data(forKey: scoresKey) {
            if let decoded = try? JSONDecoder().decode([PlayerScore].self, from: data) {
                highScores = decoded
            }
        }
    }
    
    // Save high scores to UserDefaults
    private func saveHighScores() {
        if let encoded = try? JSONEncoder().encode(highScores) {
            UserDefaults.standard.set(encoded, forKey: scoresKey)
        }
    }
}
