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
    
    init() {
        // First initialize with default values
        self.timerDuration = 60
        self.maxBubbles = 15
        
        // Then update from UserDefaults if available
        if let savedDuration = UserDefaults.standard.object(forKey: "timerDuration") as? Int {
            self.timerDuration = savedDuration
        }
        
        if let savedMaxBubbles = UserDefaults.standard.object(forKey: "maxBubbles") as? Int {
            self.maxBubbles = savedMaxBubbles
        }
    }
    
    // Reset settings to defaults
    func resetToDefaults() {
        timerDuration = 60
        maxBubbles = 15
    }
}
