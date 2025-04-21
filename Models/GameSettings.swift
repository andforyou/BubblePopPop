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
    // We'll implement this later but including it for future expansion
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
        self.timerDuration = 60
        self.maxBubbles = 15
        self.playerName = ""
        
        // Only load player name from UserDefaults
        // We intentionally don't load timerDuration or maxBubbles to always start with defaults
        if let savedPlayerName = UserDefaults.standard.string(forKey: "playerName") {
            self.playerName = savedPlayerName
        }
    }
    
    // Reset settings to defaults
    func resetToDefaults() {
        timerDuration = 60
        maxBubbles = 15
        // Note: We don't reset player name as part of defaults
    }
}
