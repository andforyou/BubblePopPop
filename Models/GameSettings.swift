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
            self.timerDuration = 60  // Default to 60 seconds
            self.maxBubbles = 15     // Default to 15 bubbles
            self.playerName = ""
            
            // We don't preload any settings from UserDefaults
            // to ensure we always start with the default values
        }
    
    // Reset settings to defaults
    func resetToDefaults() {
        timerDuration = 60
        maxBubbles = 15
        // Note: We don't reset player name as part of defaults
    }
}
