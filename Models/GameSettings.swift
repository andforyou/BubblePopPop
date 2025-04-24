//
//  GameSettings.swift
//  BubblePopPop
//
//  Created by 牙后慧 on 2025/4/21.
//

import SwiftUI
import Combine

class GameSettings: ObservableObject {
    // Game timer duration in seconds (default: 60)
    @Published var timerDuration: Int {
        didSet {
            UserDefaults.standard.set(timerDuration, forKey: "timerDuration")
        }
    }
    
    // Maximum number of bubbles (default: 15)
    @Published var maxBubbles: Int {
        didSet {
            UserDefaults.standard.set(maxBubbles, forKey: "maxBubbles")
        }
    }
    
    // Player name
    @Published var playerName: String {
        didSet {
            UserDefaults.standard.set(playerName, forKey: "playerName")
        }
    }
    
    init() {
            // Always initialize with default values
            self.timerDuration = 60  // Default to 60 seconds
            self.maxBubbles = 15     // Default to 15 bubbles
            self.playerName = ""
        }
    
    // Reset settings to defaults
    func resetToDefaults() {
        timerDuration = 60
        maxBubbles = 15
    }
}
